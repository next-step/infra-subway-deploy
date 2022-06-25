package nextstep.subway.api;


import io.restassured.RestAssured;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.context.annotation.Profile;
import org.springframework.test.context.ActiveProfiles;

@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ApiControllerTest {

    @LocalServerPort
    private int port;

    @Test
    @Profile("test")
    @DisplayName("test 환경에서 testuser가 나오는 지 확인한다.")
    void test() {
        String expected = "안녕하세요 : testuser";
        String response = RestAssured.given().port(port).get("/test")
                .then().extract().body().asString();
        Assertions.assertThat(response).isEqualTo(expected);
    }
}