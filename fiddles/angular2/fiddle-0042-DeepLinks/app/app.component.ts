import {Component} from '@angular/core';
import { ROUTER_DIRECTIVES }  from '@angular/router';
import {SidebarComponent} from './sidebar/sidebar.component';
import {ContentComponent} from './content/content.component';
import { DataService}  from './global/data.service';



@Component({
     selector: 'app',
     templateUrl: './app/app.component.html',
     styleUrls: ['./app/app.component.css'],
     providers: [DataService],
     directives: [[SidebarComponent, ContentComponent, ROUTER_DIRECTIVES]]
})
export class AppComponent {


}
