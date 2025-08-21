import { Routes } from '@angular/router';

// If you see home.component.ts, use these:
import { Home } from './pages/home/home';
import { Factions } from './pages/factions/factions';
import { Login } from './pages/login/login';
import { Account } from './pages/account/account';

export const routes: Routes = [
  { path: '', component: Home },
  { path: 'factions', component: Factions },
  { path: 'login', component: Login },
  { path: 'account', component: Account },
  { path: '**', redirectTo: '' },
];
