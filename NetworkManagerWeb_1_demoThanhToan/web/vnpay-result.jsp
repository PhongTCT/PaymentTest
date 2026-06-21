<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%!
    private String html(Object value) {
        if (value == null) return "";
        return String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    boolean success = Boolean.TRUE.equals(request.getAttribute("paymentSuccess"));
    String message = html(request.getAttribute("paymentMessage"));
    String orderId = html(request.getAttribute("paymentOrderId"));
    String transactionNo = html(request.getAttribute("paymentTransactionNo"));
    Object amountValue = request.getAttribute("paymentAmount");
    long amount = amountValue instanceof Number ? ((Number) amountValue).longValue() : 0L;
    String amountText = amount > 0 ? NumberFormat.getInstance(new Locale("vi", "VN")).format(amount) + "đ" : "";
    String sessionRole = (String) session.getAttribute("role");
    String dashboardPath = "Admin".equalsIgnoreCase(sessionRole) || "Technician".equalsIgnoreCase(sessionRole)
            ? "/staffDashboard.jsp" : "/userDashboard.jsp";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán VNPay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { color-scheme: dark; --accent: <%= success ? "#22c55e" : "#f43f5e" %>; }
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; display: grid; place-items: center; padding: 24px; color: #eef2ff; font-family: "Segoe UI", Arial, sans-serif; background: radial-gradient(circle at 50% 0, rgba(139,92,246,.2), transparent 38%), #080b14; }
        .result-card { width: min(520px, 100%); padding: 34px; border: 1px solid #28334f; border-radius: 18px; background: rgba(16,23,42,.94); box-shadow: 0 24px 70px rgba(0,0,0,.4); }
        .result-icon { width: 64px; height: 64px; display: grid; place-items: center; border-radius: 50%; color: var(--accent); background: color-mix(in srgb, var(--accent) 15%, transparent); font-size: 31px; }
        h1 { margin: 20px 0 8px; font-size: 26px; }
        .message { margin: 0 0 22px; color: #aab6d3; line-height: 1.55; }
        .details { padding: 14px 16px; border: 1px solid #2a3555; border-radius: 11px; background: #0b1120; }
        .row { display: flex; justify-content: space-between; gap: 16px; padding: 7px 0; font-size: 13px; }
        .label { color: #8491b2; } .value { text-align: right; overflow-wrap: anywhere; }
        .back { display: block; margin-top: 22px; padding: 11px 18px; border-radius: 10px; color: #fff; text-align: center; text-decoration: none; font-weight: 700; background: linear-gradient(135deg,#8b5cf6,#6366f1); }
    </style>
</head>
<body>
    <main class="result-card">
        <div class="result-icon"><i class="bi <%= success ? "bi-check2" : "bi-x-lg" %>"></i></div>
        <h1><%= success ? "Thanh toán thành công" : "Thanh toán chưa hoàn tất" %></h1>
        <p class="message"><%= message %></p>
        <% if (!orderId.isEmpty() || !transactionNo.isEmpty() || amount > 0) { %>
        <div class="details">
            <% if (!orderId.isEmpty()) { %><div class="row"><span class="label">Mã đơn hàng</span><span class="value"><%= orderId %></span></div><% } %>
            <% if (!transactionNo.isEmpty()) { %><div class="row"><span class="label">Mã VNPay</span><span class="value"><%= transactionNo %></span></div><% } %>
            <% if (amount > 0) { %><div class="row"><span class="label">Số tiền</span><span class="value"><%= amountText %></span></div><% } %>
        </div>
        <% } %>
        <a class="back" href="<%= request.getContextPath() + dashboardPath %>">Về dashboard</a>
    </main>
</body>
</html>
