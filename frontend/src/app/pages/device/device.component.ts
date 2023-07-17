import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Device } from '../../Models/Device';
import { DeltaDTO } from '../../Models/DTOs/deltaDTO';
import { Log } from '../../Models/Log';
import { Tracker } from '../../Models/Tracker';
import { DeviceService } from '../../Service/DeviceService';
import { LocationService } from '../../Service/LocationService';
import { LogService } from '../../Service/LogService';
import { TrackerService } from '../../Service/TrackerService';

@Component({
  selector: 'device',
  templateUrl: './device.component.html',
  styleUrls: ['./device.component.css']
})
export class DeviceComponent implements OnInit {
  logs: Log[];
  locations: Location[];
  trackers: Tracker[];
  device: Device;
  trackerLabels: string[] = [];
  trackerData: number[] = [];
  locationLabels: string[] = [];
  locationData: number[] = [];

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private logService: LogService,
    private trackerService: TrackerService,
    private locationService: LocationService,
    private deviceService: DeviceService) {
    let id = this.route.snapshot.paramMap.get('secureId');
    this.deviceService.getDeviceBySecureId(id).subscribe(r => {
      this.device = r;
    });

    this.logService.getLatestLogs(id).subscribe(r => {
      this.logs = r;
    });

    this.trackerService.getLatestTrackers(id).subscribe(r => {
      this.trackers = r;
    });

    this.locationService.getLatestLocations(id).subscribe(r => {
      this.locations = r;
    });

    this.locationService.getLatestLocationsPeriods(id).subscribe(r => {
      r.forEach((s) => {
        this.locationLabels.push(new Date(s.Date).toLocaleString());
        this.locationData.push(s.Delta * 0.001);
      });
    });

    this.trackerService.getLatestTrackersPeriods(id).subscribe(r => {
      r.forEach((s) => {
        this.trackerLabels.push(new Date(s.Date).toLocaleString());
        this.trackerData.push(s.Delta * 0.001);
      });
    });
  }

  getDate(milliseconds: number) {
    return new Date(milliseconds);
  }

  ngOnInit() {
    console.log('onChange fired');
  }

  ngOnChanges(...args: any[]) {
    console.log('onChange fired');
    console.log('changing', args);
  }

}
