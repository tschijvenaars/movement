import { Component, Input, OnInit, SimpleChanges } from '@angular/core';
import { TestCaseDataDTO } from '../../Models/DTOs/CaseDataDTO';

@Component({
  selector: 'synopsys',
  templateUrl: './synopsys.component.html',
  styleUrls: ['./synopsys.component.css']
})
export class SynopsysComponent implements OnInit {
  @Input() testCaseData: TestCaseDataDTO[];

  constructor() { }

  ngOnInit() {
  }

  ngOnChanges(changes: SimpleChanges) {
    
  }
}
