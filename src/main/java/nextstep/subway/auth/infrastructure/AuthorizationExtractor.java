package nextstep.subway.auth.infrastructure;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

public class AuthorizationExtractor {
    public static final String AUTHORIZATION = "Authorization";
    public static final String BEARER_TYPE = "Bearer";
    public static final String ACCESS_TOKEN_TYPE = AuthorizationExtractor.class.getSimpleName() + ".ACCESS_TOKEN_TYPE";

    private AuthorizationExtractor() {
    }

    public static String extract(HttpServletRequest request) {
        Enumeration<String> headers = request.getHeaders(AUTHORIZATION);
        while (headers.hasMoreElements()) {
            String value = headers.nextElement();
            if (isBearerType(value)) {
                request.setAttribute(ACCESS_TOKEN_TYPE, BEARER_TYPE);
                return extractAuthHeader(value);
            }
        }

        return null;
    }

    private static String extractAuthHeader(String value) {
        String authHeaderValue = value.substring(BEARER_TYPE.length()).trim();
        return (authHeaderValue.contains(","))
            ? authHeaderValue.split(",")[0]
            : authHeaderValue;
    }

    private static boolean isBearerType(String value) {
        return value.toLowerCase().startsWith(BEARER_TYPE.toLowerCase());
    }
}
