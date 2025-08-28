import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WarSubjectPage } from './war-subject-page';

describe('WarSubjectPage', () => {
  let component: WarSubjectPage;
  let fixture: ComponentFixture<WarSubjectPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [WarSubjectPage]
    })
    .compileComponents();

    fixture = TestBed.createComponent(WarSubjectPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
