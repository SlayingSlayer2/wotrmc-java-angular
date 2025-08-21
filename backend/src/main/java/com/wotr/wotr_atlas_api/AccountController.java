package com.wotr.wotr_atlas_api;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.time.Instant;

import java.util.List;

@RestController
@RequestMapping("/api/account")
@RequiredArgsConstructor
public class AccountController {
    private final JdbcTemplate jdbc;

    public record MyFactionRow(String factionCode, String factionName, String title, Instant joinedAt) {

    }

    public List<MyFactionRow> myFactions(@AuthenticationPrincipal Jwt jwt) {
        Long uuid = ((Number) jwt.getClaim("uuid")).longValue();


        String sql = """
        select f.code, f.display_name, af.title, af.joined_at
          from account_faction af
          join factions f on f.code = af.faction_code
         where af.account_id = ?
        """;

        return jdbc.query(sql, (rs, i) -> new MyFactionRow(
                rs.getString(1),
                rs.getString(2),
                rs.getString(3),
                rs.getTimestamp(4).toInstant()
        ), uuid);
    }

}
