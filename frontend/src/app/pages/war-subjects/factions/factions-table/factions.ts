import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TableModule } from 'primeng/table';   // for <p-sortIcon> used in your projected header
import { TagModule } from 'primeng/tag';       // for <p-tag> in your body template
import { TooltipModule } from 'primeng/tooltip'; // for pTooltip on the code icon

import { FactionsService } from '@services/factions.service';
import { Faction } from '@model/faction.model';
import {AppTableComponent} from '@app/commonComps/app-table/app-table';
import {ButtonDirective} from 'primeng/button';
import {ProgressSpinner} from 'primeng/progressspinner';

@Component({
  selector: 'app-factions',
  standalone: true,
  imports: [
    CommonModule,
    AppTableComponent,
    TableModule,      // needed for p-sortIcon in factions.html
    TagModule,        // needed for p-tag in factions.html
    TooltipModule
    // needed for pTooltip in factions.html
  ],
  templateUrl: './factions.html',
  styleUrls: ['./factions.scss']
})
export class Factions implements OnInit {
  private page = 'factions';
  private api = inject(FactionsService);

  rows: Faction[] = [];
  loading = true;

  ngOnInit(): void {
    this.api.getAllFactions().subscribe({
      next: (data) => {
        this.rows = data ?? [];
        console.log(JSON.stringify(this.rows));
        this.loading = false;
      },
      error: () => {
        this.rows = [];
        this.loading = false;
      }
    });
  }
}
