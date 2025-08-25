package com.wotr.wotr_atlas_api.service;

import com.wotr.wotr_atlas_api.dao.FactionDao;
import com.wotr.wotr_atlas_api.model.Faction;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FactionService {

    public final FactionDao factionDao;

    public FactionService(FactionDao factionDao) {
        this.factionDao = factionDao;
    }

    public List<Faction> getAllFactions() {
        return factionDao.findAll();
    }

}
