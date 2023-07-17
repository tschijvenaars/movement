import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { Device } from "../Models/Device";
import { Log } from "../Models/Log";
import { ApiResponse } from "../Models/Responses/ApiResponse";
import { Tracker } from "../Models/Tracker";
import { RestService } from "./RestService";

@Injectable({ providedIn: 'root' })
export class LogService extends RestService<any> {
    constructor(http: HttpClient) { super('logs', http,); }

    public getLatestLogs(secureId: string): Observable<Log[]> {
        return this.makeRequest("GET", "/getLatest/" + secureId);
    }
}