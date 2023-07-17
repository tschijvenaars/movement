import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { BaseChartDirective, Color, Label } from 'ng2-charts';
import * as pluginAnnotations from 'chartjs-plugin-annotation';
import { ChartDataSets, ChartOptions, ChartType } from 'chart.js';

@Component({
  selector: 'iq-chart',
  templateUrl: './iq-chart.component.html',
  styleUrls: ['./iq-chart.component.css']
})
export class IQChartComponent implements OnInit {

  @Input() iq: number;
  public lineChartData: ChartDataSets[] = [
    {
      data: [0, 2, 10, 65, 100, 65, 10, 2, 0],
      label: 'Series A',
      fill: true,
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
  public lineChartLabels = [40, 55, 70, 85, 100, 115, 130, 145, 160];
  public lineChartOptions: (ChartOptions & { annotation: any });
  public lineChartColors: Color[] = [{}];
  public lineChartLegend = true;
  public lineChartType: ChartType = 'line';
  public lineChartPlugins = [pluginAnnotations];

  @ViewChild(BaseChartDirective, { static: true }) chart: BaseChartDirective;
  public canvas: any;
  public ctx: any;

  ngOnInit() {
    this.lineChartOptions = {
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
          id: 'y-axis-0',
          scaleLabel: {
            display: false,
          },
          gridLines: {
            drawBorder: false,
            color: 'rgba(29,140,248,0.0)',
            zeroLineColor: "transparent",
          },
          ticks: {
            suggestedMin: 60,
            suggestedMax: 125,
            stepSize: 15,
            padding: 20,
            fontColor: "#9a9a9a",
            display: false
          }
        }],

        xAxes: [{
          id: 'x-axis-0',
          gridLines: {
            drawBorder: false,
            color: 'rgba(233,32,16,0.1)',
            zeroLineColor: "transparent",
          },
          ticks: {
            suggestedMin: 40,
            suggestedMax: 160,
            padding: 20,
            fontColor: "#9a9a9a"
          }
        }]
      },
      annotation: {
        annotations: [
          {
            type: 'line',
            mode: 'vertical',
            scaleID: 'x-axis-0',
            value: this.iq,
            borderColor: 'red',
            borderWidth: 1,
            label: {
              enabled: true,
              fontColor: 'orange',
            }
          },
        ],
      },
    };

    this.canvas = document.getElementById("chartIQ");
    this.ctx = this.canvas.getContext("2d");

    var gradientStroke = this.ctx.createLinearGradient(0, 130, 0, 50);
    gradientStroke.addColorStop(1, 'rgba(233, 32, 16, 0.1)');
    gradientStroke.addColorStop(0.4, 'rgba(233, 32, 16, 0.0)');
    gradientStroke.addColorStop(0, 'rgba(233, 32, 16, 0)');
    this.lineChartData[0].backgroundColor = gradientStroke;
  }
}
