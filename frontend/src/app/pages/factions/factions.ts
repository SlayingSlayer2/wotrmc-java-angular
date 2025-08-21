import { Component, inject, OnInit } from '@angular/core';
import { ApiService, Faction } from '../../services/api.service';

@Component({
  selector: 'app-factions',
  standalone: true,
  imports: [],
  templateUrl: './factions.html',
  styleUrl: './factions.scss'
})
export class Factions implements OnInit {
  private api = inject(ApiService);
  rows: Faction[] = [];
  ngOnInit() { this.api.getPublicFactions().subscribe(r => this.rows = r); }
}
