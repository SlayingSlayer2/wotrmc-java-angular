package com.wotr.wotr_atlas_api.web;

import com.wotr.wotr_atlas_api.model.Realm;
import com.wotr.wotr_atlas_api.service.RealmService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/realms")
public class RealmController {

    public RealmService realmService;

    public RealmController(RealmService realmService) { this.realmService = realmService;}


    @GetMapping("getAllRealms")
    public List<Realm> getAllRealms() {
        return realmService.realmDao.getAllRealms();
    }
}
