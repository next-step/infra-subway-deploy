package nextstep.subway.deploy.api;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration // 빈 등록, setter랑 getter가 있어야 바인딩 하기 편하다.
@ConfigurationProperties("account") // properties 에 있는 구분자 기준으로 값 가져오기
public class Properties {
    private String name;
    private String password;

    public void setName(String name) {
        this.name = name;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }
}