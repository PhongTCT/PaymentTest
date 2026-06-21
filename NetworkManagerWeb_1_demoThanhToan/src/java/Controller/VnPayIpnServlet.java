package Controller;

import Utils.VnPayConfig;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class VnPayIpnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        String code = "99";
        String message = "Unknown error";
        try {
            VnPayConfig config = VnPayConfig.load(getServletContext(), request);
            VnPayCallbackProcessor.Result result = VnPayCallbackProcessor.process(request, config);
            code = result.getCode();
            message = ipnMessage(code, result.isSuccess());
        } catch (SQLException | RuntimeException ex) {
            getServletContext().log("Cannot process VNPay IPN", ex);
        }
        response.getWriter().write("{\"RspCode\":\"" + json(code)
                + "\",\"Message\":\"" + json(message) + "\"}");
    }

    private String ipnMessage(String code, boolean success) {
        if ("00".equals(code)) {
            return "Confirm Success";
        }
        if ("01".equals(code)) {
            return "Order not found";
        }
        if ("02".equals(code) && success) {
            return "Order already confirmed";
        }
        if ("04".equals(code)) {
            return "Invalid amount";
        }
        if ("97".equals(code)) {
            return "Invalid signature";
        }
        return "Unknown error";
    }

    private String json(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
