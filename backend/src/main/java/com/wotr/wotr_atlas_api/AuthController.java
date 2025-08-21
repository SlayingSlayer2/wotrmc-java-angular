package com.wotr.wotr_atlas_api;

import com.wotr.wotr_atlas_api.repo.UserRepo;
import com.wotr.wotr_atlas_api.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    private final UserRepo userRepo;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwt;

    public record LoginReq(String email, String pwd){}
    public record LoginRes(String token, String displayName, String role){}

    @PostMapping("/login")
    public ResponseEntity<LoginRes> login(@RequestBody LoginReq loginReq){
        var user = userRepo.findByEmail(loginReq.email())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED));

        if(!passwordEncoder.matches(loginReq.pwd(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }

        var token = jwt.mint(user.getId(), user.getEmail(), user.getRole());

        return ResponseEntity.ok(new LoginRes(token, user.getDisplayName(), user.getRole()));
    }

    @GetMapping("/me")
    public Object me(@AuthenticationPrincipal Jwt token){
        var uuid = token.getClaim("uuid");
        return java.util.Map.of(
                "subject", token.getSubject(),
                "uuid", uuid,
                "role", token.getClaim("role"),
                "issuedAt", token.getIssuedAt(),
                "expiresAt", token.getExpiresAt());

    }
}
