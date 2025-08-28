package com.wotr.wotr_atlas_api.service;

import com.wotr.wotr_atlas_api.dao.WaypointDao;
import com.wotr.wotr_atlas_api.model.Waypoint;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WaypointService {

    private WaypointDao waypointDao;

    public WaypointService(WaypointDao waypointDao) {
        this.waypointDao = waypointDao;
    }

    public List<Waypoint> getAllWaypoints() { return waypointDao.findAll(); }
}
