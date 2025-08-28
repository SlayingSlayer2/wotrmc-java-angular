import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TableModule } from 'primeng/table';   // for <p-sortIcon> used in your projected header
import { TagModule } from 'primeng/tag';       // for <p-tag> in your body template
import { TooltipModule } from 'primeng/tooltip'; // for pTooltip on the code icon

import { RealmsService } from '@services/realms-service';
import { Realm } from '@model/realm.model';
import {AppTableComponent} from '@app/commonComps/app-table/app-table';
import {ProgressSpinner} from 'primeng/progressspinner';
import {ButtonDirective} from 'primeng/button';

@Component({
  selector: 'app-realms',
  standalone: true,
  imports: [
    CommonModule,
    AppTableComponent,
    TableModule,      // needed for p-sortIcon in realms.html
    TagModule,        // needed for p-tag in realms.html
    TooltipModule,
    ProgressSpinner,
    ButtonDirective,
    // needed for pTooltip in realms.html
  ],
  templateUrl: './realms.html',
  styleUrls: ['./realms.scss']
})
export class Realms implements OnInit {
  private api = inject(RealmsService);

  rows: Realm[] = [];
  loading = true;

  ngOnInit(): void {
    this.api.getAllRealms().subscribe({
      next: (data) => {
        this.rows = data ?? [];
        this.loading = false;
      },
      error: () => {
        this.rows = [];
        this.loading = false;
      }
    });
  }
}
