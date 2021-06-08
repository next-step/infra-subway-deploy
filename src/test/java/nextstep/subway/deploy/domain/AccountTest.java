package nextstep.subway.deploy.domain;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@ActiveProfiles("test")
@SpringBootTest
public class AccountTest {

    @Autowired
    private AccountRepository repository;

    @Test
    @DisplayName("h2를 사용하여 테스트한다")
    void constructor() {
        Account account = new Account("name");
        Account persist = repository.save(account);
        assertThat(persist.getId()).isNotNull();
    }

}