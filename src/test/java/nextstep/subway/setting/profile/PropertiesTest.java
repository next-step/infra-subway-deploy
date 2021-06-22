package nextstep.subway.setting.profile;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
@DisplayName("spring profile 테스트")
public class PropertiesTest {

	@Autowired
	private Properties properties;

	@DisplayName("application-test.properties 값을 확인한다")
	@Test
	void applicateion_test() {
		String name = properties.getName();
		String password = properties.getPassword();

		Assertions.assertThat(name).isEqualTo("testuser");
		Assertions.assertThat(password).isEqualTo("test");
	}
}
