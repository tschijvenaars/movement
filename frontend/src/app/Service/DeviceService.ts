import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { Device } from "../Models/Device";
import { ApiResponse } from "../Models/Responses/ApiResponse";
import { RestService } from "./RestService";

@Injectable({ providedIn: 'root' })
export class DeviceService extends RestService<any> {
    constructor(http: HttpClient) { super('devices', http,); }

    public getDevices(): Observable<Device[]> {
        return this.makeRequest("GET", "");
    }

    public getDeviceBySecureId(secureId: string): Observable<Device> {
        return this.makeRequest("GET", "/bySecureId/" + secureId);
    }
}