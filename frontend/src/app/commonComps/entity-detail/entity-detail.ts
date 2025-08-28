import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-entity-detail',
  templateUrl: './entity-detail.html',
})
export class EntityDetailComponent implements OnInit {
  entityType!: string;
  code!: string;

  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.entityType = this.route.snapshot.routeConfig?.path?.split('/')[0] || '';
    this.code = this.route.snapshot.params['code'];

    // TODO: Load data using entityType + code
    console.log(`Loading ${this.entityType} with code: ${this.code}`);
  }
}
