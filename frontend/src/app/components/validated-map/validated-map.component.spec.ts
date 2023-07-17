import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValidatedMapComponent } from './validated-map.component';

describe('ValidatedMapComponent', () => {
  let component: ValidatedMapComponent;
  let fixture: ComponentFixture<ValidatedMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValidatedMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValidatedMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
