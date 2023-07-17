import { Component, OnInit, AfterViewInit, Input, SimpleChanges } from '@angular/core';
import * as L from 'leaflet';
import { LatLonDTO } from '../../Models/DTOs/LatLongDTO';

@Component({
  selector: 'geo-map',
  templateUrl: './raw-map.component.html',
  styleUrls: ['./raw-map.component.css']
})
export class MapComponent implements OnInit, AfterViewInit {
  @Input() rawLocations: LatLonDTO[];

  private map;
  constructor() {
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes.rawLocations.currentValue.length > 0) {
      this.initMap(changes.rawLocations.currentValue[0].Lat, changes.rawLocations.currentValue[0].Lon);
      this.makeMarkers(this.map, changes.rawLocations.currentValue);
    }

  }

  private initMap(lat: number, lon: number): void {
    this.map = L.map('raw-map', {
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

  makeMarkers(map: L.map, rawLocations: LatLonDTO[]): void {

    for (let i = 0; i < rawLocations.length; i++) {
      const marker = L.circleMarker([rawLocations[i].Lat, rawLocations[i].Lon], { radius: 3 });
      marker.addTo(map);
    }
  }

  ngOnInit() {
  }

  ngAfterViewInit(): void {
    //this.initMap();
  }

}
