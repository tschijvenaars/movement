import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SynopsysComponent } from './synopsys.component';

describe('SynopsysComponent', () => {
  let component: SynopsysComponent;
  let fixture: ComponentFixture<SynopsysComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SynopsysComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SynopsysComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
