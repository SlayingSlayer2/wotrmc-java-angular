package com.wotr.wotr_atlas_api.model;

public class Waypoint {

    private String code;
    private String display_name;
    private String realm_code;

    public Waypoint() {
    }

    public Waypoint(String code, String display_name, String realm_code) {
        this.code = code;
        this.display_name = display_name;
        this.realm_code = realm_code;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDisplay_name() {
        return display_name;
    }

    public void setDisplay_name(String display_name) {
        this.display_name = display_name;
    }

    public String getRealm_code() {
        return realm_code;
    }

    public void setRealm_code(String realm_code) {
        this.realm_code = realm_code;
    }
}
