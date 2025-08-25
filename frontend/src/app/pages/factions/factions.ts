import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { FactionsService } from '../../services/factions.service';
import { Faction } from '../../model/faction.model';

// PrimeNG
import { TableModule } from 'primeng/table';
import { InputTextModule } from 'primeng/inputtext';
import { TagModule } from 'primeng/tag';
import { ButtonModule } from 'primeng/button';
import { TooltipModule } from 'primeng/tooltip';
import { ProgressSpinnerModule } from 'primeng/progressspinner';

@Component({
  selector: 'app-factions',
  standalone: true,
  imports: [
    CommonModule, FormsModule,
    TableModule, InputTextModule, TagModule, ButtonModule, TooltipModule, ProgressSpinnerModule
  ],
  templateUrl: './factions.html',
  styleUrls: ['./factions.scss']
})
export class Factions implements OnInit {
  private api = inject(FactionsService);

  rows: Faction[] = [];
  loading = true;
  globalFilter = '';

  ngOnInit(): void {
    this.api.getAllFactions().subscribe({
      next: data => { this.rows = data ?? []; this.loading = false; },
      error: _ => { this.rows = []; this.loading = false; }
    });
  }
}
