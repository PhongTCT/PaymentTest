package Controller;

import Models.PaymentTransactionDTO;
import Models_DAO.VnPayPaymentDAO;
import Models_DAO.VnPayPaymentDAO.CompleteResult;
import Utils.VnPayConfig;
import Utils.VnPayUtils;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

final class VnPayCallbackProcessor {

    static class Result {

        private final String code;
        private final String message;
        private final boolean success;
        private final String orderId;
        private final String transactionNo;
        private final long amount;

        Result(String code, String message, boolean success, String orderId,
                String transactionNo, long amount) {
            this.code = code;
            this.message = message;
            this.success = success;
            this.orderId = orderId;
            this.transactionNo = transactionNo;
            this.amount = amount;
        }

        String getCode() {
            return code;
        }

        String getMessage() {
            return message;
        }

        boolean isSuccess() {
            return success;
        }

        String getOrderId() {
            return orderId;
        }

        String getTransactionNo() {
            return transactionNo;
        }

        long getAmount() {
            return amount;
        }
    }

    private VnPayCallbackProcessor() {
    }

    static Result process(HttpServletRequest request, VnPayConfig config) throws SQLException {
        Map<String, String> signedFields = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String name = entry.getKey();
            if (!name.startsWith("vnp_")
                    || "vnp_SecureHash".equals(name)
                    || "vnp_SecureHashType".equals(name)) {
                continue;
            }
            String[] values = entry.getValue();
            signedFields.put(name, values != null && values.length > 0 ? values[0] : "");
        }

        String receivedHash = request.getParameter("vnp_SecureHash");
        if (!VnPayUtils.verifySignature(signedFields, receivedHash, config.getHashSecret())) {
            return new Result("97", "Chữ ký VNPay không hợp lệ", false, null, null, 0L);
        }
        if (!config.getTmnCode().equals(request.getParameter("vnp_TmnCode"))) {
            return new Result("97", "Mã website VNPay không hợp lệ", false, null, null, 0L);
        }

        String orderId = request.getParameter("vnp_TxnRef");
        String transactionNo = request.getParameter("vnp_TransactionNo");
        long amount;
        try {
            long gatewayAmount = Long.parseLong(request.getParameter("vnp_Amount"));
            if (gatewayAmount <= 0 || gatewayAmount % 100L != 0) {
                throw new NumberFormatException();
            }
            amount = gatewayAmount / 100L;
        } catch (NumberFormatException | NullPointerException ex) {
            return new Result("04", "Số tiền thanh toán không hợp lệ", false, orderId, transactionNo, 0L);
        }

        VnPayPaymentDAO dao = new VnPayPaymentDAO();
        PaymentTransactionDTO payment = dao.findByOrderId(orderId);
        if (payment == null) {
            return new Result("01", "Không tìm thấy đơn hàng", false, orderId, transactionNo, amount);
        }
        if (payment.getAmount() != amount) {
            return new Result("04", "Số tiền không khớp với đơn hàng", false, orderId, transactionNo, amount);
        }

        String responseCode = request.getParameter("vnp_ResponseCode");
        String transactionStatus = request.getParameter("vnp_TransactionStatus");
        boolean paid = "00".equals(responseCode) && "00".equals(transactionStatus);
        if (!paid) {
            dao.markFailed(orderId, responseCode, transactionNo);
            return new Result("00", "Giao dịch chưa thành công (mã " + safeCode(responseCode) + ")",
                    false, orderId, transactionNo, amount);
        }

        CompleteResult completed = dao.completePayment(orderId, amount,
                request.getParameter("vnp_BankCode"), transactionNo, responseCode,
                request.getParameter("vnp_PayDate"));
        switch (completed) {
            case SUCCESS:
                return new Result("00", "Thanh toán thành công", true, orderId, transactionNo, amount);
            case ALREADY_SUCCESS:
                return new Result("02", "Đơn hàng đã được xác nhận trước đó", true, orderId, transactionNo, amount);
            case INVALID_AMOUNT:
                return new Result("04", "Số tiền không hợp lệ", false, orderId, transactionNo, amount);
            default:
                return new Result("01", "Không tìm thấy đơn hàng", false, orderId, transactionNo, amount);
        }
    }

    private static String safeCode(String code) {
        return code == null || !code.matches("[0-9A-Za-z_-]{1,20}") ? "không xác định" : code;
    }
}
