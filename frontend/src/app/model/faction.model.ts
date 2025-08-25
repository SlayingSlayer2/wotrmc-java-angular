// src/app/factions/faction.model.ts
export interface Faction {
  code: string;
  displayName: string;
  banner?: string | null;
  capitalWaypoint?: string | null;
  lordName?: string | null;
}
