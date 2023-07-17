import { HttpHeaders, HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { ApiResponse } from '../Models/Responses/ApiResponse';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';

export class RestService<T> {
  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    })
  };
  private _apiEndPoint: string = environment.apiUrl + "";
  constructor(private _url: string, private _http: HttpClient) { }

  // common method
  makeRequest<TData>(method: string, prefixUrl?: string, data?: any)
    : Observable<TData> {
    prefixUrl = prefixUrl != undefined ? prefixUrl : "";
    let finalUrl: string = this._apiEndPoint + this._url + prefixUrl;
    let body: any = null;
    if (method.toUpperCase() == 'GET' && data) {
      finalUrl += '?' + this.objectToQueryString(data);
    }
    else {
      body = data;
    }
    var apiResponse = this._http.request<ApiResponse<string>>(
      method.toUpperCase(),
      finalUrl,
      { body: body });

    return apiResponse.pipe(map(r => {
      return JSON.parse(r.Body);
    }));
  }

  private objectToQueryString(obj: any): string {
    var str = [];
    for (var p in obj)
      if (obj.hasOwnProperty(p)) {
        str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
      }
    return str.join("&");
  }
}