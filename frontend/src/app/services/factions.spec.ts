import { TestBed } from '@angular/core/testing';

import { Factions } from './factions.service';

describe('Factions', () => {
  let service: Factions;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Factions);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
