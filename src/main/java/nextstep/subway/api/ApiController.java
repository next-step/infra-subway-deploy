package nextstep.subway.api;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping
@Slf4j
public class ApiController {
    private final Properties properties;

    public ApiController(Properties properties) {
        this.properties = properties;
    }

    @GetMapping("/test")
    public String index() {
        String name = properties.getName();
        log.info("current user : {}", name);
        return "안녕하세요 : " + name;
    }
}
