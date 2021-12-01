package nextstep.subway.account.api;


import nextstep.subway.account.domain.Account;
import nextstep.subway.account.domain.AccountRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping
@RestController
public class ApiAccountController {
    private final AccountRepository repository;

    public ApiAccountController(AccountRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/accounts")
    public String save(@RequestParam String name) {
        System.out.println(name);
        return repository.save(new Account(name)).getName();
    }
}
