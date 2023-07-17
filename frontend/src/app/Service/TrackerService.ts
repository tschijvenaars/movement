import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { Device } from "../Models/Device";
import { DeltaDTO } from "../Models/DTOs/deltaDTO";
import { ApiResponse } from "../Models/Responses/ApiResponse";
import { Tracker } from "../Models/Tracker";
import { RestService } from "./RestService";

@Injectable({ providedIn: 'root' })
export class TrackerService extends RestService<any> {
    constructor(http: HttpClient) { super('trackers', http,); }

    public getLatestTrackers(secureId: string): Observable<Tracker[]> {
        return this.makeRequest("GET", "/getLatest/" + secureId);
    }

    public getLatestTrackersPeriods(secureId: string): Observable<DeltaDTO[]> {
        return this.makeRequest("GET", "/GetLatestTrackersPeriods/" + secureId);
    }
}