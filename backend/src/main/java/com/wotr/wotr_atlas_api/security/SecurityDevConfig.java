package com.wotr.wotr_atlas_api.security;

import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest;
import org.springframework.boot.actuate.health.HealthEndpoint;
import org.springframework.context.annotation.*;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

// Actuator helpers

@Configuration
@Profile("dev")
public class SecurityDevConfig {

    @Bean
    SecurityFilterChain devSecurity(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable());

        http.authorizeHttpRequests(auth -> auth
                // Allow health (Actuator) explicitly using EndpointRequest
                .requestMatchers(EndpointRequest.to(HealthEndpoint.class)).permitAll()
                // Your simple ping
                .requestMatchers("/api/ping").permitAll()
                // Everything else open in dev (or keep authenticated if you prefer)
                .anyRequest().permitAll()
        );

        return http.build();
    }
}
