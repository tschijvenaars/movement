import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { BaseChartDirective, Color, Label } from 'ng2-charts';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'dam-chart',
  templateUrl: './dam-chart.component.html',
  styleUrls: ['./dam-chart.component.css']
})
export class DamChartComponent implements OnInit {

  @Input() labels: string[] = [];
  @ViewChild('baseChart', { static: false }) chart: BaseChartDirective;
  _data: BehaviorSubject<number[]> = new BehaviorSubject<number[]>([]);

  @Input() set data(value: number[]) {
    this._data.next(value);
  }

  get model() {
    return this._data.getValue();
  }

  public canvas: any;
  public ctx;

  public lineChartData: Chart.ChartDataSets[] = [
    {
      data: this.data, label: 'Series A', fill: true,
      backgroundColor: "white",
      borderColor: '#ec250d',
      borderWidth: 2,
      borderDash: [],
      borderDashOffset: 0.0,
      pointBackgroundColor: '#ec250d',
      pointBorderColor: 'rgba(255,255,255,0)',
      pointHoverBackgroundColor: '#ec250d',
      pointBorderWidth: 20,
      pointHoverRadius: 4,
      pointHoverBorderWidth: 15,
      pointRadius: 4,
    },
  ];
  public lineChartLabels: Label[] = [];
  public lineChartOptions: (Chart.ChartOptions & { annotation: any }) = {
    annotation: true,
    maintainAspectRatio: false,
    legend: {
      display: false
    },

    tooltips: {
      backgroundColor: '#f5f5f5',
      titleFontColor: '#333',
      bodyFontColor: '#666',
      bodySpacing: 4,
      xPadding: 12,
      mode: "nearest",
      position: "nearest"
    },
    responsive: true,
    scales: {
      yAxes: [{
        gridLines: {
          drawBorder: false,
          color: 'rgba(29,140,248,0.0)',
          zeroLineColor: "transparent",
        },
        ticks: {
          //suggestedMin: 60,
          //suggestedMax: 125,
          padding: 20,
          fontColor: "#9a9a9a"
        }
      }],

      xAxes: [{
        gridLines: {
          drawBorder: false,
          color: 'rgba(233,32,16,0.1)',
          zeroLineColor: "transparent",
        },
        ticks: {
          padding: 20,
          fontColor: "#9a9a9a"
        }
      }]
    }
  }

  public lineChartColors: Color[] = [{}];
  public lineChartLegend = true;
  public lineChartType = 'line';

  constructor() {
    this._data.subscribe(data => {
      if (this.chart) {
        this.chart.chart.destroy();

        this.chart.datasets[0].data = data;
        this.lineChartLabels = this.labels;
        this.chart.ngOnInit();
      }
      this.lineChartData[0].data = [];
      this.lineChartData[0].data = data;
      this.lineChartLabels = this.labels;
    });
  }

  ngOnInit() {
    this.canvas = document.getElementById("chartMortgage");
    this.ctx = this.canvas.getContext("2d");

    var gradientStroke = this.ctx.createLinearGradient(0, 130, 0, 50);
    gradientStroke.addColorStop(1, 'rgba(233, 32, 16, 0.1)');
    gradientStroke.addColorStop(0.4, 'rgba(233, 32, 16, 0.0)');
    gradientStroke.addColorStop(0, 'rgba(233, 32, 16, 0)');
    this.lineChartData[0].backgroundColor = gradientStroke;
  }

}
