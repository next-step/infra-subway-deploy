package nextstep.subway;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.StringJoiner;

@RestController
@RequestMapping("/active-profile")
public class ActiveProfileController {
    private static final String DELIMITER = ",";
    private static final Logger log = LoggerFactory.getLogger(ActiveProfileController.class);

    private final Environment environment;

    public ActiveProfileController(Environment environment) {
        this.environment = environment;
    }

    @GetMapping()
    public String index() {
        return getActiveProfiles();
    }

    public String getActiveProfiles() {
        final StringJoiner activeUsers = new StringJoiner(DELIMITER);
        for (String profileName : environment.getActiveProfiles()) {
            log.info("Currently active profile - {}", profileName);
            activeUsers.add(profileName);
        }
        return activeUsers.toString();
    }
}
