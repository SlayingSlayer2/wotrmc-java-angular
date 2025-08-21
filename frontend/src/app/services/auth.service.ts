import { Injectable, signal, computed, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { tap } from 'rxjs/operators';

type LoginReq = { email: string; password: string };
type LoginRes = { token: string; displayName: string; role: string };

@Injectable({ providedIn: 'root' })
export class AuthService {
  private http = inject(HttpClient);

  private tokenSig = signal<string | null>(localStorage.getItem('token'));
  private nameSig  = signal<string | null>(localStorage.getItem('name'));
  isAuthed = computed(() => !!this.tokenSig());

  get token() { return this.tokenSig(); }
  get displayName() { return this.nameSig(); }

  login(req: LoginReq) {
    return this.http.post<LoginRes>('/auth/login', req).pipe(
      tap(res => {
        localStorage.setItem('token', res.token);
        localStorage.setItem('name', res.displayName);
        this.tokenSig.set(res.token);
        this.nameSig.set(res.displayName);
      })
    );
  }

  logout() {
    localStorage.removeItem('token'); localStorage.removeItem('name');
    this.tokenSig.set(null); this.nameSig.set(null);
  }
}
