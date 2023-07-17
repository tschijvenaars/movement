import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DamChartComponent } from './dam-chart.component';

describe('DamChartComponent', () => {
  let component: DamChartComponent;
  let fixture: ComponentFixture<DamChartComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DamChartComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DamChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
