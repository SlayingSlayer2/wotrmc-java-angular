package com.wotr.wotr_atlas_api.repo;

import com.wotr.wotr_atlas_api.model.Faction;
import org.apache.catalina.Realm;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RealmRepo extends JpaRepository<Faction, String> {}
