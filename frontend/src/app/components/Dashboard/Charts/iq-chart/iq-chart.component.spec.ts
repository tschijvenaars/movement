import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { IQChartComponent } from './iq-chart.component';

describe('IQChartComponent', () => {
  let component: IQChartComponent;
  let fixture: ComponentFixture<IQChartComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ IQChartComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(IQChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
