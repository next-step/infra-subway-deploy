package nextstep.subway;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {
    private Properties properties;

    public PageController(Properties properties) {
        this.properties = properties;
    }

    @GetMapping(value = {
            "/",
            "/stations",
            "/lines",
            "/sections",
            "/path",
            "/login",
            "/join",
            "/mypage",
            "/mypage/edit",
            "/favorites"}, produces = MediaType.TEXT_HTML_VALUE)
    public String index() {
        String name = properties.getName();
        String password = properties.getPassword();
        System.out.printf("user name : %s, password : %s\n", name, password);
        return "checkIndex : " + name;
    }
}
