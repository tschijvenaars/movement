import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { Device } from "../Models/Device";
import { DeltaDTO } from "../Models/DTOs/deltaDTO";
import { ApiResponse } from "../Models/Responses/ApiResponse";
import { RestService } from "./RestService";

@Injectable({ providedIn: 'root' })
export class LocationService extends RestService<any> {
    constructor(http: HttpClient) { super('locations', http,); }

    public getLatestLocations(secureId: string): Observable<Location[]> {
        return this.makeRequest("GET", "/getLatest/" + secureId);
    }

    public getLatestLocationsPeriods(secureId: string): Observable<DeltaDTO[]> {
        return this.makeRequest("GET", "/GetLatestLocationsPeriods/" + secureId);
    }
}