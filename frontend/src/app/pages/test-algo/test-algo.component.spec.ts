import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TestAlgoComponent } from './test-algo.component';

describe('TestAlgoComponent', () => {
  let component: TestAlgoComponent;
  let fixture: ComponentFixture<TestAlgoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TestAlgoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TestAlgoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
