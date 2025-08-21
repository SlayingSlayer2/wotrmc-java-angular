package com.wotr.wotr_atlas_api.security;

import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class JwtService {
    private final JwtEncoder jwtEncoder;
    @Value("${app.jwt.issuer}") String issuer;
    @Value("${app.jwt.ttl-seconds}") long ttlSeconds;


    public JwtService(JwtEncoder jwtEncoder) {
        this.jwtEncoder = jwtEncoder;
    }

    public String mint(Long uuid, String email, String role){
        var instantNow = Instant.now();
        var claims = JwtClaimsSet.builder()
                .issuer(issuer)
                .issuedAt(instantNow)
                .expiresAt(instantNow.plusSeconds(ttlSeconds))
                .subject(email)
                .claim("uuid", uuid)
                .claim("role", role)
                .build();
        return jwtEncoder.encode(JwtEncoderParameters.from(claims)).getTokenValue();
    }
}
