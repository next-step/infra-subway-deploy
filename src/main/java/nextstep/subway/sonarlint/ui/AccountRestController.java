//package nextstep.subway.sonarlint.ui;
//
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//
//public class AccountRestController {
//
//    @PostMapping
//    public ResponseEntity<?> create(@RequestBody AccountDto.Create create) {
//        Account created = accountService.create(create);
//        return ResponseEntity.created(toLocationUri(created.getId())).build();
//    }
//}
