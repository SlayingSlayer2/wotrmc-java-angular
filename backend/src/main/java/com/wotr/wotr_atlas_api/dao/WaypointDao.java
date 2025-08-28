package com.wotr.wotr_atlas_api.dao;

import com.wotr.wotr_atlas_api.model.Waypoint;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class WaypointDao {

    public JdbcTemplate jdbcTemplate;

    public WaypointDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public static class WaypointMapper implements RowMapper<Waypoint> {

        @Override
        public Waypoint mapRow(ResultSet rs, int rowNum) throws SQLException {
            Waypoint w = new Waypoint();
            w.setCode(rs.getString("code"));
            w.setDisplay_name(rs.getString("display_name"));
            w.setRealm_code(rs.getString("realm_code"));
            return w;
        }
    }

    public List<Waypoint> findAll() {
        return jdbcTemplate.query("SELECT code, display_name, realm_code FROM waypoints", new WaypointMapper());
    }
}
