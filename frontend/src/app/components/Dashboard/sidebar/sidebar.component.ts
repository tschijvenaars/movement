import { Component, OnInit } from '@angular/core';
import { Device } from '../../../Models/Device';
import { DeviceService } from '../../../Service/DeviceService';

@Component({
  selector: "app-sidebar",
  templateUrl: "./sidebar.component.html",
  styleUrls: ["./sidebar.component.css"]
})
export class SidebarComponent implements OnInit {
  devices: Device[];

  constructor(private deviceService: DeviceService) {
   this.deviceService.getDevices().subscribe(response => {
     console.log(response);
     this.devices = response;
   })
  }

  ngOnInit() {
  }

  isMobileMenu() {
    if (window.innerWidth > 991) {
      return false;
    }
    return true;
  }
}