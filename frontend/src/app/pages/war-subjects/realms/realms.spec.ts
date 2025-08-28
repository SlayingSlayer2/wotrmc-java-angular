import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Realms } from './realms';

describe('Realms', () => {
  let component: Realms;
  let fixture: ComponentFixture<Realms>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Realms]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Realms);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
