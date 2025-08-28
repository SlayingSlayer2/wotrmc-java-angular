package com.wotr.wotr_atlas_api.service;

import com.wotr.wotr_atlas_api.dao.RealmDao;
import com.wotr.wotr_atlas_api.model.Realm;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RealmService {

    public RealmDao realmDao;

    public RealmService(RealmDao realmDao) { this.realmDao = realmDao;}

    private List<Realm> getAllRealms() {
        return realmDao.getAllRealms();
    }


}
