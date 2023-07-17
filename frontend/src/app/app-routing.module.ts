import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { DeviceComponent } from './pages/device/device.component';
import { TestAlgoComponent } from './pages/test-algo/test-algo.component';


const routes: Routes = [
  { path: '', redirectTo: '/test-algo', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'test-algo', component: TestAlgoComponent },
  { path: 'device/:secureId', component: DeviceComponent },
  // otherwise redirect to home
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
