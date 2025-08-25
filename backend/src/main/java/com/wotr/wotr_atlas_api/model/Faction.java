package com.wotr.wotr_atlas_api.model;

import jakarta.persistence.*;
import lombok.*;

@Entity @Table(name = "factions")
@Getter @Setter @Builder
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

    public Faction() {}

    public Faction(String code,String displayName, String banner, String capitalWaypoint, String lordName) {
        this.code = code;
        this.displayName = displayName;
        this.banner = banner;
        this.capitalWaypoint = capitalWaypoint;
        this.lordName = lordName;
    }

    public String getCode(){
        return code;
    }

    public void setCode(String code){
        this.code = code;
    }

    public String getDisplayName(){
        return displayName;
    }

    public void setDisplayName(String displayName){
        this.displayName = displayName;
    }

    public String getBanner(){
        return this.banner;
    }

    public void setBanner(String banner){
        this.banner = banner;
    }

    public String getCapitalWaypoint(){
        return this.capitalWaypoint;
    }

    public void setCapitalWaypoint(String capitalWaypoint){
        this.capitalWaypoint = capitalWaypoint;
    }

    public String getLordName(){
        return lordName;
    }

    public void setLordName(String lordName){
        this.lordName = lordName;
    }


}