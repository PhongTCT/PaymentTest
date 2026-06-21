package Controller;

import Utils.VnPayConfig;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VnPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        try {
            VnPayConfig config = VnPayConfig.load(getServletContext(), request);
            VnPayCallbackProcessor.Result result = VnPayCallbackProcessor.process(request, config);
            request.setAttribute("paymentSuccess", result.isSuccess());
            request.setAttribute("paymentMessage", result.getMessage());
            request.setAttribute("paymentOrderId", result.getOrderId());
            request.setAttribute("paymentTransactionNo", result.getTransactionNo());
            request.setAttribute("paymentAmount", result.getAmount());
        } catch (SQLException | RuntimeException ex) {
            getServletContext().log("Cannot process VNPay return", ex);
            request.setAttribute("paymentSuccess", false);
            request.setAttribute("paymentMessage", "Không thể xác nhận giao dịch. Vui lòng liên hệ hỗ trợ.");
        }
        request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
    }
}
