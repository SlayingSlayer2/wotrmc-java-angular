package com.wotr.wotr_atlas_api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class PasswordConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // Supports {bcrypt}, {noop}, {pbkdf2}, etc. Default is bcrypt.
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
        // Or, if you prefer strictly bcrypt:
        // return new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
    }
}
