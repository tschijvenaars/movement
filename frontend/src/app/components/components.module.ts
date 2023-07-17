import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";

import { SidebarComponent } from './Dashboard/sidebar/sidebar.component';
import { NavbarComponent } from './Dashboard/navbar/navbar.component';
import { FooterComponent } from './Dashboard/footer/footer.component';
import { ValidatedMapComponent } from './validated-map/validated-map.component';
import { AlgoMapComponent } from './algo-map/algo-map.component';
import { SecMapComponent } from './sec-map/sec-map.component';

@NgModule({
  imports: [CommonModule, RouterModule, NgbModule],
  declarations: [FooterComponent, NavbarComponent, SidebarComponent],
  exports: [FooterComponent, NavbarComponent, SidebarComponent]
})
export class ComponentsModule {}