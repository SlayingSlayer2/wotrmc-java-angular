package com.wotr.wotr_atlas_api.repo;

import com.wotr.wotr_atlas_api.model.Faction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FactionRepo extends JpaRepository<Faction, String> {}  // String because @Id is 'code'
