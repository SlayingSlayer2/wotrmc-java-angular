package com.wotr.wotr_atlas_api.model;


public class Realm {

    private String codeName;
    private String displayName;
    private String banner;
    private String capitalWaypoint;

    public Realm() {}

    public Realm(String codeName, String displayName, String banner, String capitalWaypoint) {
        this.codeName = codeName;
        this.displayName = displayName;
        this.banner = banner;
        this.capitalWaypoint = capitalWaypoint;
    }

    public String getCodeName() { return this.codeName; }
    public String getDisplayName() { return this.displayName; }
    public String getBanner() { return this.banner; }
    public String getCapitalWaypoint() { return this.capitalWaypoint; }

    public void setCodeName(String codeName){
        this.codeName = codeName;
    }

    public void setDisplayName(String displayName){
        this.displayName = displayName;
    }

    public void setBanner(String banner){
        this.banner = banner;
    }

    public void setCapitalWaypoint(String capitalWaypoint){
        this.capitalWaypoint = capitalWaypoint;
    }
}
