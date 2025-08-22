package com.wotr.wotr_atlas_api.config;

import java.nio.charset.StandardCharsets;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;

import com.nimbusds.jose.jwk.source.ImmutableSecret;

@Configuration
@Profile("dev")
public class DevJwtConfig {

    // Keep this in application-dev.properties; see step 2
    private static final String ALGO = "HmacSHA256";

    @Bean
    JwtEncoder jwtEncoder(org.springframework.core.env.Environment env) {
        String secret = env.getProperty("jwt.secret",
                "change-me-dev-secret-change-me-dev-secret-change-me!");
        SecretKeySpec key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), ALGO);
        return new NimbusJwtEncoder(new ImmutableSecret<>(key));
    }

    @Bean
    JwtDecoder jwtDecoder(org.springframework.core.env.Environment env) {
        String secret = env.getProperty("jwt.secret",
                "change-me-dev-secret-change-me-dev-secret-change-me!");
        SecretKeySpec key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), ALGO);
        return NimbusJwtDecoder.withSecretKey(key)
                .macAlgorithm(MacAlgorithm.HS256)
                .build();
    }
}
