package com.wotr.wotr_atlas_api.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name = "app_user")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@ToString(exclude = "passwordHash")
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true) private String email;
    @Column(nullable = false) private String displayName;
    @Column(nullable = false) private String passwordHash;
    @Column(nullable = false) private String role;
}
