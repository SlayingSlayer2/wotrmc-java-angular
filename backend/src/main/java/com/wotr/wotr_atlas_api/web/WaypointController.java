package com.wotr.wotr_atlas_api.web;

import com.wotr.wotr_atlas_api.model.Waypoint;
import com.wotr.wotr_atlas_api.service.WaypointService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/realms")
public class WaypointController {

    private WaypointService waypointService;

    public WaypointController(WaypointService waypointService) {
        this.waypointService = waypointService;
    }

    @GetMapping("getAllWaypoints")
    public List<Waypoint> getAllWaypoints() {
        return waypointService.getAllWaypoints();
    }
}
