import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Waypoints } from './waypoints';

describe('Waypoints', () => {
  let component: Waypoints;
  let fixture: ComponentFixture<Waypoints>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Waypoints]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Waypoints);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
