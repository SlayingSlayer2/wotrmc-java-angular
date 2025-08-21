package com.wotr.wotr_atlas_api.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name = "factions")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@EqualsAndHashCode(of = "code")
@ToString
public class Faction{
    @Id @Column(length = 64)
    private String code;

    @Column(name = "display_name", nullable = false)
    private String displayName;

    private String banner;
    private String capitalWaypoint;
    private String lordName;
}