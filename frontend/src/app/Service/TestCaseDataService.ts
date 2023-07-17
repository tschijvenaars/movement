import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { TestCaseDataDTO } from "../Models/DTOs/CaseDataDTO";
import { TrackedLocationDTO } from "../Models/DTOs/TrackedLocationDTO";
import { ApiResponse } from "../Models/Responses/ApiResponse";
import { RestService } from "./RestService";

@Injectable({ providedIn: 'root' })
export class TestCaseDataService extends RestService<any> {
    constructor(http: HttpClient) { super('api/testcasedata', http); }

    public getTestCaseData(): Observable<TestCaseDataDTO[]> {
        return this.makeRequest<TestCaseDataDTO[]>("GET", "");
    } 
}