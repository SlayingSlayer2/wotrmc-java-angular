import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { tap } from 'rxjs/operators';
import { WAR_SUBJECTS, WarSubjectCopy, WarSubjectKey } from '@app/pages/war-subjects/war-subjects';
import { CommonModule } from '@angular/common';
import { TableModule } from 'primeng/table';
import { TabsModule } from 'primeng/tabs';

type Row = any;

@Component({
  selector: 'war-subject-page',
  standalone: true,
  templateUrl: './war-subject-page.html',
  imports: [CommonModule, TableModule, TabsModule],
  styleUrls: ['./war-subject-page.scss']
})
export class WarSubjectPage implements OnInit {
  key!: WarSubjectKey;
  header!: WarSubjectCopy;

  cols: { field: string; header: string }[] = [];
  rows: Row[] = [];
  loading = true;

  constructor(private route: ActivatedRoute, private http: HttpClient, private router: Router) {}

  ngOnInit() {
    this.key = this.route.snapshot.data['subjectKey'] as WarSubjectKey;
    this.header = WAR_SUBJECTS[this.key];

    if (this.key === 'FACTIONS') {
      this.cols = [
        { field: 'displayName', header: 'Name' },
        // { field: 'code',        header: 'Code' },
        { field: 'lordName',    header: 'Lord' },
        { field: 'capitalWaypoint', header: 'Capital' }
      ];

      this.http.get<Row[]>('/api/factions/getAllFactions')
        .pipe(tap(() => (this.loading = false)))
        .subscribe((data) => (this.rows = data || []));
    } else if (this.key === 'WAYPOINTS') {
      this.cols = [
        { field: 'code',        header: 'Code' },
        { field: 'displayName', header: 'Name' },
        { field: 'realmCode', header: 'Realm' }
      ];

      this.http.get<Row[]>('/api/realms/getAllWaypoints')
        .pipe(tap(() => (this.loading = false)))
        .subscribe((data) => (this.rows = data || []));
    } else if (this.key === 'REALMS') {
      this.cols = [
        { field: 'code',        header: 'Code' },
        { field: 'displayName', header: 'Name' },
        { field: 'realmCode', header: 'Realm' }
      ];

      this.http.get<Row[]>('/api/realms/getAllRealms')
        .pipe(tap(() => (this.loading = false)))
        .subscribe((data) => (this.rows = data || []));
    }
  }

  onRowClick(row: Row) {
    if (this.key === 'FACTIONS') this.router.navigate(['/factions', row.code]);
  }
}
