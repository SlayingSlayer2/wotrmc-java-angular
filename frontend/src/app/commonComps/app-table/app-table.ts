import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// PrimeNG
import { TableModule } from 'primeng/table';
import { InputTextModule } from 'primeng/inputtext';
import { ButtonModule } from 'primeng/button';
import { ProgressSpinnerModule } from 'primeng/progressspinner';

// Router
import { RouterLink } from '@angular/router';

type Row = Record<string, any>;

@Component({
  selector: 'app-table',
  standalone: true,
  templateUrl: './app-table.html',
  styleUrls: ['./app-table.scss'],
  imports: [
    CommonModule,
    FormsModule,
    RouterLink,

    TableModule,
    InputTextModule,
    ButtonModule,
    ProgressSpinnerModule
  ]
})
export class AppTableComponent<T extends Row = Row> {
  @Input() title?: string;

  @Input() value: T[] = [];
  @Input() columns: Array<{ field: string; header: string }> = [];

  @Input() globalFilterFields: string[] = [];

  @Input() rows = 10;
  @Input() rowsPerPageOptions: number[] = [10, 25, 50];

  @Input() loading = false;
  @Input() dataKey = 'code';
  @Input() exportFileName?: string;

  @Input() showGlobalSearch = true;
  @Input() showExport = true;

  // 🔗 Make a column render as a link: /<linkBase>/<codeLower>
  @Input() entityType?: string;        // e.g. "/factions"
  @Input() linkField = 'displayName';// which column becomes a link
  @Input() codeField = 'code';       // which field is used in URL

  globalFilter = '';

  toDetailLink(row: T): any[] | null {
    if (!this.entityType) return null;
    const code = String(row?.[this.codeField] ?? '').toLowerCase();
    if (!code) return null;
    // Accepts linkBase with or without leading slash
    const base = this.entityType.startsWith('/') ? this.entityType : `/${this.entityType}`;
    return [base, code];
  }
}
