import {inject, Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Realm} from '@model/realm.model';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class RealmsService {

  private httpClient = inject(HttpClient);
  private baseApi = "api/realms";

  getAllRealms(): Observable<Realm[]> {
    return this.httpClient.get<Realm[]>(`${this.baseApi}/getAllRealms`);
  }

}
