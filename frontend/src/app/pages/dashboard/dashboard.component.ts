import { BreakpointObserver } from '@angular/cdk/layout';
import { Component, OnInit } from "@angular/core";
import { ChartDataSets, ChartType, RadialChartOptions, ChartLegendLabelOptions } from 'chart.js';
import { Color, Label } from 'ng2-charts';
import { Device } from '../../Models/Device';
import { DeviceService } from '../../Service/DeviceService';


@Component({
  selector: "app-dashboard",
  templateUrl: "dashboard.component.html"
})
export class DashboardComponent implements OnInit {
  devices: Device[];
  
  constructor(private deviceService: DeviceService) {
    this.deviceService.getDevices().subscribe(r => {
      this.devices = r;
    })
  }

  ngOnInit(): void {

  }

}
