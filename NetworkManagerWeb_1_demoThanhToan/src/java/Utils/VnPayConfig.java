package Utils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

public class VnPayConfig {

    private final String tmnCode;
    private final String hashSecret;
    private final String payUrl;
    private final String returnUrl;
    private final long premiumAmount;

    private VnPayConfig(String tmnCode, String hashSecret, String payUrl,
            String returnUrl, long premiumAmount) {
        this.tmnCode = tmnCode;
        this.hashSecret = hashSecret;
        this.payUrl = payUrl;
        this.returnUrl = returnUrl;
        this.premiumAmount = premiumAmount;
    }

    public static VnPayConfig load(ServletContext context, HttpServletRequest request) {
        String tmnCode = setting("VNPAY_TMN_CODE", context.getInitParameter("vnpay.tmnCode"));
        String hashSecret = setting("VNPAY_HASH_SECRET", context.getInitParameter("vnpay.hashSecret"));
        String payUrl = setting("VNPAY_PAY_URL", context.getInitParameter("vnpay.payUrl"));
        String configuredReturnUrl = setting("VNPAY_RETURN_URL", context.getInitParameter("vnpay.returnUrl"));
        String amountText = setting("VNPAY_PREMIUM_AMOUNT", context.getInitParameter("vnpay.premiumAmount"));

        if (!hasText(tmnCode) || "CHANGE_ME".equals(tmnCode)) {
            throw new IllegalStateException("Chưa cấu hình VNPAY_TMN_CODE cho môi trường Sandbox");
        }
        if (!hasText(hashSecret) || "CHANGE_ME".equals(hashSecret)) {
            throw new IllegalStateException("Chưa cấu hình VNPAY_HASH_SECRET cho môi trường Sandbox");
        }
        if (!hasText(payUrl)) {
            payUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
        }
        long amount = 99000L;
        if (hasText(amountText)) {
            try {
                amount = Long.parseLong(amountText);
            } catch (NumberFormatException ex) {
                throw new IllegalStateException("VNPAY_PREMIUM_AMOUNT không hợp lệ");
            }
        }
        if (amount < 5000L || amount > 1000000000L) {
            throw new IllegalStateException("Số tiền Premium nằm ngoài giới hạn cho phép");
        }

        String returnUrl = hasText(configuredReturnUrl)
                ? configuredReturnUrl
                : buildApplicationUrl(request, "/vnpay-return");
        return new VnPayConfig(tmnCode, hashSecret, payUrl, returnUrl, amount);
    }

    public static String buildApplicationUrl(HttpServletRequest request, String path) {
        String forwardedProto = firstHeaderValue(request.getHeader("X-Forwarded-Proto"));
        String forwardedHost = firstHeaderValue(request.getHeader("X-Forwarded-Host"));
        String scheme = hasText(forwardedProto) ? forwardedProto : request.getScheme();
        String authority;
        if (hasText(forwardedHost)) {
            authority = forwardedHost;
        } else {
            int port = request.getServerPort();
            boolean defaultPort = ("http".equalsIgnoreCase(scheme) && port == 80)
                    || ("https".equalsIgnoreCase(scheme) && port == 443);
            authority = request.getServerName() + (defaultPort ? "" : ":" + port);
        }
        return scheme + "://" + authority + request.getContextPath() + path;
    }

    private static String setting(String environmentName, String fallback) {
        String environmentValue = System.getenv(environmentName);
        return hasText(environmentValue) ? environmentValue.trim() : (fallback == null ? null : fallback.trim());
    }

    private static String firstHeaderValue(String value) {
        if (!hasText(value)) {
            return null;
        }
        int comma = value.indexOf(',');
        return (comma >= 0 ? value.substring(0, comma) : value).trim();
    }

    private static boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public String getTmnCode() {
        return tmnCode;
    }

    public String getHashSecret() {
        return hashSecret;
    }

    public String getPayUrl() {
        return payUrl;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public long getPremiumAmount() {
        return premiumAmount;
    }
}
