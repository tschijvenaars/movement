import { Component, OnInit, Input } from '@angular/core';
import { ChartDataSets, ChartType, ChartOptions } from 'chart.js';
import { Label } from 'ng2-charts';

@Component({
  selector: 'bar-chart',
  templateUrl: './bar-chart.component.html',
  styleUrls: ['./bar-chart.component.css']
})
export class BarChartComponent implements OnInit {

  @Input()
  set labels(labels: string[]) {
    this.barChartLabels = labels;
  }
  
  @Input()
  set data(data: number[]) {
    this.barChartData[0].data = data;
  }
  
  constructor() { }

  ngOnInit() {
  }

  public barChartOptions: ChartOptions = {
    responsive: true,
    // We use these empty structures as placeholders for dynamic theming.
    scales: { xAxes: [{}], yAxes: [{}] },
    plugins: {
      datalabels: {
        anchor: 'end',
        align: 'end',
      }
    }
  };

  public barChartData: ChartDataSets[] = [
    { data: []},
  ];
  public barChartLabels: Label[];
  public barChartType: ChartType = 'bar';
  public barChartLegend = true;

  // events
  public chartClicked({ event, active }: { event: MouseEvent, active: {}[] }): void {
    console.log(event, active);
  }

  public chartHovered({ event, active }: { event: MouseEvent, active: {}[] }): void {
    console.log(event, active);
  }

}
