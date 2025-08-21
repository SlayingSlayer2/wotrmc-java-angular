import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

export interface Faction { code: string; displayName: string; banner?: string; }
export interface MyFactionRow { factionCode: string; factionName: string; title: string; joinedAt: string; }

@Injectable({ providedIn: 'root' })
export class ApiService {
  private http = inject(HttpClient);

  getPublicFactions() {
    return this.http.get<Faction[]>('/api/public/factions');
  }
  getMyFactions() {
    return this.http.get<MyFactionRow[]>('/api/account/factions'); // JWT required
  }
}
