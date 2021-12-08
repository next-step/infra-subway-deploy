package nextstep.subway;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.context.ActiveProfiles;

import static io.restassured.RestAssured.given;
import static org.assertj.core.api.Assertions.assertThat;

@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ActiveProfileControllerTest {

    @LocalServerPort
    private int port;

    @DisplayName("현재 active profile 을 확인한다. - test")
    @Test
    void properties() {
        String expected = "test";
        String response = given()
                .port(port)
                .get("/active-profile")
                .then().extract().body().asString();

        assertThat(response).isEqualTo(expected);
    }
}