import {inject, Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Faction} from './api.service';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FactionsService {

  private http = inject(HttpClient);
  private baseUrl = "api/factions";

  getAllFactions(): Observable<Faction[]> {
    return this.http.get<Faction[]>(`${this.baseUrl}/getAllFactions`)
  }

}
