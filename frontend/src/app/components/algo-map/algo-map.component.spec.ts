import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AlgoMapComponent } from './algo-map.component';

describe('AlgoMapComponent', () => {
  let component: AlgoMapComponent;
  let fixture: ComponentFixture<AlgoMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AlgoMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AlgoMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
