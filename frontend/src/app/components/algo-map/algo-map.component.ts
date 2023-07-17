import { Component, OnInit, AfterViewInit, Input, SimpleChanges } from '@angular/core';
import * as L from 'leaflet';
import { SecondAlgoDTO } from '../../Models/DTOs/SecondAlgoDTO';
import { TrackedDayDTO } from '../../Models/DTOs/TrackedDayDTO';
import { TrackedLocationDTO } from '../../Models/DTOs/TrackedLocationDTO';
import { TrackedMovementDTO } from '../../Models/DTOs/TrackedMovementDTO';

@Component({
  selector: 'algo-map',
  templateUrl: './algo-map.component.html',
  styleUrls: ['./algo-map.component.css']
})
export class AlgoMapComponent implements OnInit, AfterViewInit {
  colors: string[] = ['red', 'black', 'blue', 'purple', 'pink', 'orange'];
  polyLineIndex = 0;
  private map;
  @Input() results: SecondAlgoDTO;

  constructor() { }
  ngOnInit(): void {
    
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes.results.currentValue != null && changes.results.currentValue.locations.length > 0) {
      this.initMap(changes.results.currentValue.locations[0].Lat, changes.results.currentValue.locations[0].Lon);
      
      this.generateMovements(this.map, changes.results.currentValue.movements);
      this.makeLocationMarkers(this.map, changes.results.currentValue.locations);
      
    }
  }

  private initMap(lat: number, lon: number): void {
    this.map = L.map('algo-map', {
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

  
  makeLocationMarkers(map: L.map, locations: TrackedLocationDTO[]): void {
    for (let i = 0; i < locations.length; i++) {
      const marker = L.circleMarker([locations[i].Lat, locations[i].Lon], { radius: 3 });
      marker.addTo(map);
    }
  }

  generateMovements(map: L.map, movements: TrackedMovementDTO[]) {
      for (let j = 0; j < movements.length; j++) {
        this.makePolyLine(map, movements[j]);
      }
  }

  makePolyLine(map: L.map, movement: TrackedMovementDTO) {
    if(this.polyLineIndex == this.colors.length) {
      this.polyLineIndex = 0;
    } else {
      this.polyLineIndex++;
    }


    var latlons = [];
    for (let i = 0; i < movement.TrackedLatLons.length; i++) {
      latlons.push([movement.TrackedLatLons[i].Lat, movement.TrackedLatLons[i].Lon])
    }

    var poly = new L.polyline(latlons, {
      color: this.colors[this.polyLineIndex],
      weight: 5,
      opacity: 1,
      smoothFactor: 1
    });

    poly.addTo(map);
  }

  ngAfterViewInit(): void {
  }
}
