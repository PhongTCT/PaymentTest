package Models_DAO;

import Models.PaymentTransactionDTO;
import Utils.DbUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VnPayPaymentDAO {

    public enum CompleteResult {
        SUCCESS,
        ALREADY_SUCCESS,
        ORDER_NOT_FOUND,
        INVALID_AMOUNT
    }

    public boolean createPending(String orderId, int userId, long amount, String orderInfo,
            String clientIp) throws SQLException {
        String sql = "INSERT INTO PaymentTransaction "
                + "(order_id, user_id, amount, currency, status, provider, order_info, client_ip) "
                + "VALUES (?, ?, ?, 'VND', 'PENDING', 'VNPAY', ?, ?)";
        try (Connection connection = connection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, orderId);
            statement.setInt(2, userId);
            statement.setLong(3, amount);
            statement.setString(4, orderInfo);
            statement.setString(5, clientIp);
            return statement.executeUpdate() == 1;
        }
    }

    public PaymentTransactionDTO findByOrderId(String orderId) throws SQLException {
        String sql = "SELECT payment_id, order_id, user_id, amount, status, bank_code, "
                + "transaction_no, response_code, created_at, paid_at "
                + "FROM PaymentTransaction WHERE order_id = ?";
        try (Connection connection = connection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, orderId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? map(result) : null;
            }
        }
    }

    public CompleteResult completePayment(String orderId, long amount, String bankCode,
            String transactionNo, String responseCode, String payDate) throws SQLException {
        Connection connection = connection();
        try {
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            PaymentTransactionDTO payment = findAndLock(connection, orderId);
            if (payment == null) {
                connection.rollback();
                return CompleteResult.ORDER_NOT_FOUND;
            }
            if (payment.getAmount() != amount) {
                connection.rollback();
                return CompleteResult.INVALID_AMOUNT;
            }
            if ("SUCCESS".equals(payment.getStatus())) {
                connection.commit();
                return CompleteResult.ALREADY_SUCCESS;
            }

            String updatePayment = "UPDATE PaymentTransaction SET status = 'SUCCESS', bank_code = ?, "
                    + "transaction_no = ?, response_code = ?, vnp_pay_date = ?, paid_at = CURRENT_TIMESTAMP "
                    + "WHERE payment_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(updatePayment)) {
                statement.setString(1, bankCode);
                statement.setString(2, transactionNo);
                statement.setString(3, responseCode);
                statement.setString(4, payDate);
                statement.setLong(5, payment.getPaymentId());
                statement.executeUpdate();
            }

            String updateSubscription = "UPDATE PremiumSubscription SET plan_code = 'PREMIUM_MONTHLY', "
                    + "status = 'ACTIVE', expires_at = CASE WHEN expires_at > CURRENT_TIMESTAMP "
                    + "THEN expires_at + INTERVAL '1 month' ELSE CURRENT_TIMESTAMP + INTERVAL '1 month' END, "
                    + "last_payment_id = ? WHERE user_id = ?";
            int updated;
            try (PreparedStatement statement = connection.prepareStatement(updateSubscription)) {
                statement.setLong(1, payment.getPaymentId());
                statement.setInt(2, payment.getUserId());
                updated = statement.executeUpdate();
            }
            if (updated == 0) {
                String insertSubscription = "INSERT INTO PremiumSubscription "
                        + "(user_id, plan_code, status, started_at, expires_at, last_payment_id) "
                        + "VALUES (?, 'PREMIUM_MONTHLY', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1 month', ?)";
                try (PreparedStatement statement = connection.prepareStatement(insertSubscription)) {
                    statement.setInt(1, payment.getUserId());
                    statement.setLong(2, payment.getPaymentId());
                    statement.executeUpdate();
                }
            }
            connection.commit();
            return CompleteResult.SUCCESS;
        } catch (SQLException ex) {
            rollbackQuietly(connection);
            throw ex;
        } finally {
            closeQuietly(connection);
        }
    }

    public void markFailed(String orderId, String responseCode, String transactionNo) throws SQLException {
        String sql = "UPDATE PaymentTransaction SET status = 'FAILED', response_code = ?, transaction_no = ? "
                + "WHERE order_id = ? AND status = 'PENDING'";
        try (Connection connection = connection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, responseCode);
            statement.setString(2, transactionNo);
            statement.setString(3, orderId);
            statement.executeUpdate();
        }
    }

    private PaymentTransactionDTO findAndLock(Connection connection, String orderId) throws SQLException {
        String sql = "SELECT payment_id, order_id, user_id, amount, status, bank_code, "
                + "transaction_no, response_code, created_at, paid_at "
                + "FROM PaymentTransaction WITH (UPDLOCK, ROWLOCK) WHERE order_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, orderId);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? map(result) : null;
            }
        }
    }

    private PaymentTransactionDTO map(ResultSet result) throws SQLException {
        PaymentTransactionDTO payment = new PaymentTransactionDTO();
        payment.setPaymentId(result.getLong("payment_id"));
        payment.setOrderId(result.getString("order_id"));
        payment.setUserId(result.getInt("user_id"));
        payment.setAmount(result.getLong("amount"));
        payment.setStatus(result.getString("status"));
        payment.setBankCode(result.getString("bank_code"));
        payment.setTransactionNo(result.getString("transaction_no"));
        payment.setResponseCode(result.getString("response_code"));
        payment.setCreatedAt(result.getTimestamp("created_at"));
        payment.setPaidAt(result.getTimestamp("paid_at"));
        return payment;
    }

    private Connection connection() throws SQLException {
        try {
            return DbUtils.getConnection();
        } catch (ClassNotFoundException ex) {
            throw new SQLException("SQL Server JDBC driver is unavailable", ex);
        }
    }

    private void rollbackQuietly(Connection connection) {
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void closeQuietly(Connection connection) {
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }
}
