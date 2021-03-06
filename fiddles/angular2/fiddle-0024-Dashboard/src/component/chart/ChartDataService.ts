import {Component, enableProdMode, Injectable} from 'angular2/core';
import {Http, Headers, HTTP_PROVIDERS} from 'angular2/http';
import 'rxjs/add/operator/map';



@Injectable()
export class ChartDataService {
    constructor(private http: Http) {}
    request(url:String) {
        return this.http
            .get(url)
            .map(res => res.json());


    }
}

