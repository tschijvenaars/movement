import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { ChartsModule, ThemeService } from 'ng2-charts';
// import { AlertModule } from 'ngx-bootstrap';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MatIconModule } from '@angular/material/icon';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { CapitalizeFirstLetterPipe } from './Pipes/CapitalizeFirstLetterPipe';
import { NgSelectModule } from '@ng-select/ng-select';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AgePipe } from './Pipes/AgePipe';
import { BarChartComponent } from './Components/Charts/bar-chart/bar-chart.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ToastrModule } from 'ngx-toastr';
import { SecMapComponent } from './Components/sec-map/sec-map.component';
import { FooterComponent } from './Components/Dashboard/footer/footer.component';
import { NavbarComponent } from './Components/Dashboard/navbar/navbar.component';
import { SidebarComponent } from './Components/Dashboard/sidebar/sidebar.component';
import { IQChartComponent } from './Components/Dashboard/Charts/iq-chart/iq-chart.component';
import { DamChartComponent } from './Components/Dashboard/Charts/dam-chart/dam-chart.component';
import { Ng5SliderModule } from 'ng5-slider';
import { MatStepperModule } from '@angular/material/stepper';
import { MatFormFieldModule, MatInputModule } from '@angular/material';
import { ComponentsModule } from './Components/components.module';
import { SynopsisComponent } from './Components/Dashboard/synopsis/synopsis.component';
import { TimeAgoPipe } from 'time-ago-pipe';
import { DeviceComponent } from './pages/device/device.component';
import { TestAlgoComponent } from './pages/test-algo/test-algo.component';
import { MapComponent } from './components/raw-map/raw-map.component';
import { AlgoMapComponent } from './Components/algo-map/algo-map.component';
import { ValidatedMapComponent } from './Components/validated-map/validated-map.component';
import { SynopsysComponent } from './components/synopsys/synopsys.component';

@NgModule({
  declarations: [
    AppComponent,
    CapitalizeFirstLetterPipe,
    AgePipe,
    BarChartComponent,
    DashboardComponent,
    SecMapComponent,
    IQChartComponent,
    IQChartComponent,
    DamChartComponent,
    SynopsisComponent,
    TimeAgoPipe,
    DeviceComponent,
    TestAlgoComponent,
    MapComponent,
    AlgoMapComponent,
    ValidatedMapComponent,
    SynopsysComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    MatIconModule,
    MatProgressBarModule,
    HttpClientModule,
    ChartsModule,
    NgSelectModule, 
    ComponentsModule,
    FormsModule,
    NgbModule,
    MatFormFieldModule,
    MatInputModule,
    MatStepperModule,
    Ng5SliderModule,
    ToastrModule.forRoot(), 
    ReactiveFormsModule
  ],
  exports: [
    AgePipe,
    CapitalizeFirstLetterPipe
  ],
  providers: [ThemeService],
  bootstrap: [AppComponent]
})
export class AppModule { }
