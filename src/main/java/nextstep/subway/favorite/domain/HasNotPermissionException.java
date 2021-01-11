package nextstep.subway.favorite.domain;

public class HasNotPermissionException extends RuntimeException {
    public HasNotPermissionException(String message) {
        super(message);
    }
}
