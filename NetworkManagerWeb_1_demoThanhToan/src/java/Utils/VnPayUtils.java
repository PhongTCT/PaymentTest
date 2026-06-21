package Utils;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public final class VnPayUtils {

    private VnPayUtils() {
    }

    public static String buildHashData(Map<String, String> parameters) {
        List<String> keys = new ArrayList<>(parameters.keySet());
        Collections.sort(keys);
        StringBuilder data = new StringBuilder();
        for (String key : keys) {
            String value = parameters.get(key);
            if (value == null || value.isEmpty()) {
                continue;
            }
            if (data.length() > 0) {
                data.append('&');
            }
            data.append(urlEncode(key)).append('=').append(urlEncode(value));
        }
        return data.toString();
    }

    public static String buildQuery(Map<String, String> parameters) {
        return buildHashData(parameters);
    }

    public static String hmacSHA512(String secret, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            hmac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder result = new StringBuilder(bytes.length * 2);
            for (byte value : bytes) {
                result.append(String.format("%02x", value & 0xff));
            }
            return result.toString();
        } catch (NoSuchAlgorithmException | InvalidKeyException ex) {
            throw new IllegalStateException("Cannot create VNPay signature", ex);
        }
    }

    public static boolean verifySignature(Map<String, String> parameters, String receivedHash, String secret) {
        if (receivedHash == null || receivedHash.isEmpty()) {
            return false;
        }
        String expected = hmacSHA512(secret, buildHashData(parameters));
        return constantTimeEquals(expected, receivedHash);
    }

    public static boolean constantTimeEquals(String left, String right) {
        if (left == null || right == null) {
            return false;
        }
        byte[] a = left.toLowerCase().getBytes(StandardCharsets.US_ASCII);
        byte[] b = right.toLowerCase().getBytes(StandardCharsets.US_ASCII);
        int diff = a.length ^ b.length;
        int length = Math.max(a.length, b.length);
        for (int i = 0; i < length; i++) {
            byte av = i < a.length ? a[i] : 0;
            byte bv = i < b.length ? b[i] : 0;
            diff |= av ^ bv;
        }
        return diff == 0;
    }

    private static String urlEncode(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            throw new IllegalStateException(ex);
        }
    }
}
