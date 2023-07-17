import { Component, OnInit, AfterViewInit, Input, SimpleChanges } from '@angular/core';
import * as L from 'leaflet';
import { LatLonDTO } from '../../Models/DTOs/LatLongDTO';
import { SecondAlgoDTO } from '../../Models/DTOs/SecondAlgoDTO';

@Component({
  selector: 'sec-map',
  templateUrl: './sec-map.component.html',
  styleUrls: ['./sec-map.component.css']
})
export class SecMapComponent implements OnInit, AfterViewInit {
  @Input() rawLocations: SecondAlgoDTO;

  private map;
  constructor() {
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes.rawLocations.currentValue.correctPoints.length > 0) {
      this.initMap(changes.rawLocations.currentValue.correctPoints[0].Lat, changes.rawLocations.currentValue.correctPoints[0].Lon);
      this.makeCorrectMarkers(this.map, changes.rawLocations.currentValue.correctPoints);
      this.makeInCorrectMarkers(this.map, changes.rawLocations.currentValue.inCorrectPoints);
    }

  }

  private initMap(lat: number, lon: number): void {
    this.map = L.map('sec-map', {
      center: [lat, lon],
      zoom: 12
    });

    const tiles = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 18,
      minZoom: 3,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    });

    tiles.addTo(this.map);
  }

  makeCorrectMarkers(map: L.map, rawLocations: LatLonDTO[]): void {
    if(!rawLocations) {
      return;
    }

    for (let i = 0; i < rawLocations.length; i++) {
      const marker = L.circleMarker([rawLocations[i].Lat, rawLocations[i].Lon], { radius: 3 });
      marker.addTo(map);
    }
  }

  makeInCorrectMarkers(map: L.map, rawLocations: LatLonDTO[]): void {
    if(!rawLocations) {
      return;
    }

    for (let i = 0; i < rawLocations.length; i++) {
      const marker = L.circleMarker([rawLocations[i].Lat, rawLocations[i].Lon], { radius: 3, color: 'red' });
      marker.addTo(map);
    }
  }

  ngOnInit() {
  }

  ngAfterViewInit(): void {
    //this.initMap();
  }

}
