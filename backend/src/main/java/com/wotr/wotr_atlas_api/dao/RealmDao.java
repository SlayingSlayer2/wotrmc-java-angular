package com.wotr.wotr_atlas_api.dao;

import com.wotr.wotr_atlas_api.model.Realm;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class RealmDao {

    private JdbcTemplate jdbcTemplate;

    public RealmDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    private static class RealmMapper implements RowMapper<Realm> {
        @Override
        public Realm mapRow(ResultSet rs, int rowNum) throws SQLException {
            Realm r = new Realm();
            r.setCodeName(rs.getString("code"));
            r.setDisplayName(rs.getString("display_name"));
            r.setBanner(rs.getString("banner"));
            r.setCapitalWaypoint(rs.getString("capital_waypoint"));
            return r;
        }
    }

    public List<Realm> getAllRealms() {
        return jdbcTemplate.query("SELECT code, display_name, banner, capital_waypoint FROM realms", new RealmMapper());
    }
}
