import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { Login } from './pages/login/login';
import { Account } from './pages/account/account';
import { EntityDetailComponent } from './commonComps/entity-detail/entity-detail';
import { authGuard } from './auth.guard';
import { WarSubjectPage } from '@app/pages/war-subjects/war-subject-page';

export const routes: Routes = [
  { path: '', component: Home },
  { path: 'factions',  component: WarSubjectPage, data: { subjectKey: 'FACTIONS' } },
  { path: 'realms',    component: WarSubjectPage, data: { subjectKey: 'REALMS' } },
  { path: 'waypoints', component: WarSubjectPage, data: { subjectKey: 'WAYPOINTS' } },
  { path: 'factions/:code',  component: EntityDetailComponent },
  { path: 'realms/:code',    component: EntityDetailComponent },
  { path: 'waypoints/:code', component: EntityDetailComponent },
  { path: 'login', component: Login },
  { path: 'account', component: Account, canActivate: [authGuard] },
  { path: '**', redirectTo: '' }
];
