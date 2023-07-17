import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SecMapComponent } from './sec-map.component';

describe('SecMapComponent', () => {
  let component: SecMapComponent;
  let fixture: ComponentFixture<SecMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SecMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SecMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
