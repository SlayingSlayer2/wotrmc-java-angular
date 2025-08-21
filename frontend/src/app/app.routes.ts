import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Factions } from './pages/factions/factions';
import { Login } from './pages/login/login';
import { Account } from './pages/account/account';
import { authGuard } from './auth.guard';

export const routes: Routes = [
  { path: '', component: Home },
  { path: 'factions', component: Factions },
  { path: 'login', component: Login },
  { path: 'account', component: Account, canActivate: [authGuard] },
  { path: '**', redirectTo: '' }
];
