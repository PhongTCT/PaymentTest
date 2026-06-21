package Controller;

import Models.UserDTO;
import Models_DAO.VnPayPaymentDAO;
import Utils.VnPayConfig;
import Utils.VnPayUtils;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VnPayCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        UserDTO user = session == null ? null : (UserDTO) session.getAttribute("user");
        String role = session == null ? null : (String) session.getAttribute("role");
        if (user == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String expectedCsrf = (String) session.getAttribute("vnpayCsrfToken");
        String receivedCsrf = request.getParameter("csrfToken");
        if (!VnPayUtils.constantTimeEquals(expectedCsrf, receivedCsrf)) {
            showError(request, response, "Phiên thanh toán không hợp lệ. Vui lòng tải lại dashboard và thử lại.");
            return;
        }

        try {
            VnPayConfig config = VnPayConfig.load(getServletContext(), request);
            String orderId = "PREM" + user.getUserId() + System.currentTimeMillis()
                    + UUID.randomUUID().toString().substring(0, 6).replace("-", "").toUpperCase();
            String orderInfo = "Premium 1 thang cho tai khoan " + user.getUsername();
            String clientIp = clientIp(request);

            VnPayPaymentDAO dao = new VnPayPaymentDAO();
            if (!dao.createPending(orderId, user.getUserId(), config.getPremiumAmount(), orderInfo, clientIp)) {
                throw new IllegalStateException("Không thể tạo đơn hàng");
            }

            TimeZone vietnamTime = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
            Calendar calendar = Calendar.getInstance(vietnamTime);
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            formatter.setTimeZone(vietnamTime);

            Map<String, String> parameters = new HashMap<>();
            parameters.put("vnp_Version", "2.1.0");
            parameters.put("vnp_Command", "pay");
            parameters.put("vnp_TmnCode", config.getTmnCode());
            parameters.put("vnp_Amount", String.valueOf(config.getPremiumAmount() * 100L));
            parameters.put("vnp_CurrCode", "VND");
            parameters.put("vnp_TxnRef", orderId);
            parameters.put("vnp_OrderInfo", orderInfo);
            parameters.put("vnp_OrderType", "other");
            parameters.put("vnp_Locale", "vn");
            parameters.put("vnp_ReturnUrl", config.getReturnUrl());
            parameters.put("vnp_IpAddr", clientIp);
            parameters.put("vnp_CreateDate", formatter.format(calendar.getTime()));
            calendar.add(Calendar.MINUTE, 15);
            parameters.put("vnp_ExpireDate", formatter.format(calendar.getTime()));

            String bankCode = request.getParameter("bankCode");
            if (bankCode != null && bankCode.matches("[A-Za-z0-9]{2,20}")) {
                parameters.put("vnp_BankCode", bankCode);
            }

            String hashData = VnPayUtils.buildHashData(parameters);
            String secureHash = VnPayUtils.hmacSHA512(config.getHashSecret(), hashData);
            String paymentUrl = config.getPayUrl() + "?" + VnPayUtils.buildQuery(parameters)
                    + "&vnp_SecureHash=" + secureHash;
            response.sendRedirect(paymentUrl);
        } catch (IllegalStateException ex) {
            getServletContext().log("Cannot create VNPay payment", ex);
            showError(request, response, "Không thể khởi tạo VNPay: " + ex.getMessage());
        } catch (Exception ex) {
            getServletContext().log("Cannot create VNPay payment", ex);
            showError(request, response, "Không thể khởi tạo giao dịch. Vui lòng kiểm tra cấu hình và thử lại.");
        }
    }

    private void showError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("paymentSuccess", false);
        request.setAttribute("paymentMessage", message);
        request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
    }

    private String clientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        String ip = forwarded == null ? request.getRemoteAddr() : forwarded.split(",")[0].trim();
        return ip != null && ip.matches("[0-9a-fA-F:.]{1,45}") ? ip : "127.0.0.1";
    }
}
