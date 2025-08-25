package com.wotr.wotr_atlas_api.dao;

import com.wotr.wotr_atlas_api.model.Faction;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class FactionDao {

    private final JdbcTemplate jdbcTemplate;

    public FactionDao(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }

    private static class FactionMapper implements RowMapper<Faction> {
        @Override
        public Faction mapRow(ResultSet rs, int rowNum) throws SQLException {
            Faction f = new Faction();
            f.setCode(rs.getString("code"));
            f.setDisplayName(rs.getString("display_name"));
            f.setBanner(rs.getString("banner"));
            f.setCapitalWaypoint(rs.getString("capital_waypoint"));
            f.setLordName(rs.getString("lord_name"));
            return f;
        }
    }

    public List<Faction> findAll(){
        return jdbcTemplate.query("SELECT code, display_name, banner, capital_waypoint, lord_name FROM factions", new FactionMapper());
    }
}
