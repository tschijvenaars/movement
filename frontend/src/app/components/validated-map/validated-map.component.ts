import { Component, OnInit, AfterViewInit, Input, SimpleChanges } from '@angular/core';
import * as L from 'leaflet';
import { LatLonDTO } from '../../Models/DTOs/LatLongDTO';
import { TrackedDayDTO } from '../../Models/DTOs/TrackedDayDTO';
import { TrackedLocationDTO } from '../../Models/DTOs/TrackedLocationDTO';
import { TrackedMovementDTO } from '../../Models/DTOs/TrackedMovementDTO';

@Component({
  selector: 'validated-map',
  templateUrl: './validated-map.component.html',
  styleUrls: ['./validated-map.component.css']
})
export class ValidatedMapComponent implements OnInit, AfterViewInit {
  private map;
  @Input() day: TrackedDayDTO;

  constructor() { }

  ngOnChanges(changes: SimpleChanges) {
    if (changes.day.currentValue != null) {
      this.initMap(changes.day.currentValue.TrackedLocations[0].Lat, changes.day.currentValue.TrackedLocations[0].Lon);
      this.makeMarkers(this.map, changes.day.currentValue.TrackedLocations);
      this.generateMovements(this.map, changes.day.currentValue.TrackedLocations);
    }
  }

  private initMap(lat: number, lon: number): void {
    this.map = L.map('validated-map', {
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

  ngOnInit() {
  }

  makeMarkers(map: L.map, locations: TrackedLocationDTO[]): void {
    for (let i = 0; i < locations.length; i++) {
      const marker = L.circleMarker([locations[i].Lat, locations[i].Lon], { radius: 3 });
      marker.addTo(map);
    }
  }

  generateMovements(map: L.map, locations: TrackedLocationDTO[]) {
    for (let i = 0; i < locations.length; i++) {
      for (let j = 0; j < locations[i].TrackedMovements.length; j++) {
        console.log(locations[i].TrackedMovements[j]);
        this.makePolyLine(map, locations[i].TrackedMovements[j]);
      }
    }
  }

  makePolyLine(map: L.map, movement: TrackedMovementDTO) {
    console.log(movement.TrackedLatLons);
    var latlons = [];
    for (let i = 0; i < movement.TrackedLatLons.length; i++) {
      latlons.push([movement.TrackedLatLons[i].Lat, movement.TrackedLatLons[i].Lon])
    }

    var poly = new L.polyline(latlons, {
      color: 'green',
      weight: 5,
      opacity: 1,
      smoothFactor: 1
    });

    poly.addTo(map);
  }

  ngAfterViewInit(): void {
    //this.initMap();
  }

}
