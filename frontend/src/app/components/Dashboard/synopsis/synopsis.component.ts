import { Component, Input, OnInit } from '@angular/core';
import { Log } from '../../../Models/Log';
import { Tracker } from '../../../Models/Tracker';
import { LocationService } from '../../../Service/LocationService';
import { LogService } from '../../../Service/LogService';
import { TrackerService } from '../../../Service/TrackerService';

@Component({
  selector: 'dashboard-synopsis',
  templateUrl: './synopsis.component.html',
  styleUrls: ['./synopsis.component.css']
})
export class SynopsisComponent implements OnInit {
  @Input() secureId: string;
  logs: Log[];
  locations: Location[];
  trackers: Tracker[];

  constructor(private logService: LogService, private trackerService: TrackerService, private locationService: LocationService) {
    
  }

  ngOnInit() {
    console.log(this.secureId);
    this.logService.getLatestLogs(this.secureId).subscribe(r => {
      this.logs = r;
    });

    this.trackerService.getLatestTrackers(this.secureId).subscribe(r => {
      this.trackers = r;
    });

    this.locationService.getLatestLocations(this.secureId).subscribe(r => {
      this.locations = r;
    });
  }

  getDate(milliseconds: number) {
    return new Date(milliseconds);
  }

}
