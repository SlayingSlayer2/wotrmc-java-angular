package com.wotr.wotr_atlas_api;

import com.wotr.wotr_atlas_api.model.Faction;
import com.wotr.wotr_atlas_api.service.FactionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/factions")
public class FactionController {

    public final FactionService factionService;

    public FactionController(FactionService factionService) {
        this.factionService = factionService;
    }

    @GetMapping("getAllFactions")
    public List<Faction> getAllFactions() {
        return factionService.getAllFactions();
    }

}
