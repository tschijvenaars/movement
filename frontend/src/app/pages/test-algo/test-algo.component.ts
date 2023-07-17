import { Component, OnInit } from '@angular/core';
import { angularMath } from 'angular-ts-math';
import { TestCaseDataDTO } from '../../Models/DTOs/CaseDataDTO';
import { ComparedMovementDTO } from '../../Models/DTOs/ComparedMovementDTO';
import { LatLonDTO } from '../../Models/DTOs/LatLongDTO';
import { SecondAlgoDTO } from '../../Models/DTOs/SecondAlgoDTO';
import { TrackedDayDTO } from '../../Models/DTOs/TrackedDayDTO';
import { TrackedLocationDTO } from '../../Models/DTOs/TrackedLocationDTO';
import { TrackedMovementDTO } from '../../Models/DTOs/TrackedMovementDTO';
import { SecondAlgoService } from '../../Service/SecondAlgoService';
import { SimpleAlgoService } from '../../Service/SimpleAlgoService';
import { TestCaseDataService } from '../../Service/TestCaseDataService';

@Component({
  selector: 'test-algo',
  templateUrl: './test-algo.component.html',
  styleUrls: ['./test-algo.component.css']
})
export class TestAlgoComponent implements OnInit {
  testCases: TestCaseDataDTO[];
  rawLocations: LatLonDTO[];
  calculatedPoints: SecondAlgoDTO;

  day: TrackedDayDTO;
  selectedCase: TestCaseDataDTO;
  synopsys: boolean = true;
  selectedAlgoCase: SecondAlgoDTO;


  correctMovementCounter = 0;
  incorrectMovementCounter = 0;

  correctLocationCount = 0;
  incorrectLocationCount = 0;

  constructor(private testCaseDataService: TestCaseDataService, private simpleAlgoService: SimpleAlgoService, private secondAlgoService: SecondAlgoService) {
    this.testCaseDataService.getTestCaseData().subscribe(response => {
      this.testCases = response;

      if (this.testCases.length > 0) {
        this.rawLocations = this.testCases[0].RawData;


        this.day = this.testCases[0].ValidatedData;
        this.selectedCase = this.testCases[0];
        //this.selectedAlgoCase = this.simpleAlgoService.calculateMovement(this.testCases[0].RawData);
        console.log("Generated tracked locations:");
        console.log(this.selectedAlgoCase);
        //this.compareDay();
      }
    });
  }

  ngOnInit() { }

  getDate(seconds: number): string {

    var date = new Date(seconds);

    return date.toDateString();
  }

  clickTestCase(index: number) {
    this.synopsys = false;
    this.rawLocations = this.testCases[index].RawData;

    
    this.calculatedPoints = this.secondAlgoService.calculateMovement(this.testCases[index].RawData);
    this.selectedAlgoCase = this.calculatedPoints;
    

    this.day = this.testCases[index].ValidatedData;
    this.selectedCase = this.testCases[index];
  }

  clickSynopsys() {
    this.synopsys = true;
  }

  compareDay() {
    this.compareMovement();
    this.compareLocation();
  }

  compareMovement() {
    let movementTimeRange = 10 * 60 * 1000; //10 minutes
    let movementDistanceRange = 300; //300 meters

    let validatedData: TrackedLocationDTO[] = this.selectedCase.ValidatedData.TrackedLocations;
    let generatedData: TrackedLocationDTO[] = this.selectedAlgoCase.locations;

    let allValidatedMovements: TrackedMovementDTO[] = [];
    let allGeneratedMovement: TrackedMovementDTO[] = [];

    validatedData.forEach((location) => allValidatedMovements.push(...location.TrackedMovements));
    generatedData.forEach((location) => allGeneratedMovement.push(...location.TrackedMovements));

    for (let i = 0; i < allValidatedMovements.length; i++) {
      var movements = allGeneratedMovement.filter((movement) =>
        movement.StartTime >= allValidatedMovements[i].StartTime - movementTimeRange
        && movement.StartTime <= allValidatedMovements[i].StartTime + movementTimeRange
        && movement.EndTime >= allValidatedMovements[i].EndTime - movementTimeRange
        && movement.EndTime <= allValidatedMovements[i].EndTime + movementTimeRange
        && this.calculateDistance(allValidatedMovements[i].TrackedLatLons[0].Lat, allValidatedMovements[i].TrackedLatLons[0].Lon, movement.TrackedLatLons[0].Lat, movement.TrackedLatLons[0].Lon) <= movementDistanceRange
        && this.calculateDistance(allValidatedMovements[i].TrackedLatLons[allValidatedMovements[i].TrackedLatLons.length - 1].Lat, allValidatedMovements[i].TrackedLatLons[allValidatedMovements[i].TrackedLatLons.length - 1].Lon, movement.TrackedLatLons[movement.TrackedLatLons.length - 1].Lat, movement.TrackedLatLons[movement.TrackedLatLons.length - 1].Lon) <= movementDistanceRange);

      console.log(movements);

      if (movements.length > 0) {
        this.correctMovementCounter++;
      } else {
        this.incorrectMovementCounter++;
      }
    }
  }

  compareLocation() {
    let locationTimeRange = 10 * 60 * 1000; //10 minutes
    let locationDistanceRange = 300; //300 meters

    let validatedData: TrackedLocationDTO[] = this.selectedCase.ValidatedData.TrackedLocations;
    let generatedData: TrackedLocationDTO[] = this.selectedAlgoCase.locations;


    for (let i = 0; i < validatedData.length; i++) {
      var locations = generatedData.filter((location) =>
        location.StartTime >= validatedData[i].StartTime - locationTimeRange
        && location.StartTime <= validatedData[i].StartTime + locationTimeRange
        && location.EndTime >= validatedData[i].EndTime - locationTimeRange
        && location.EndTime <= validatedData[i].EndTime + locationTimeRange
        && this.calculateDistance(validatedData[i].Lat, validatedData[i].Lon, location.Lat, location.Lon) <= locationDistanceRange
      );

      console.log(locations);

      if (locations.length > 0) {
        this.correctLocationCount++;
      } else {
        this.incorrectLocationCount++;
      }
    }
  }

  calculateDistance(lat1, lon1, lat2, lon2): number {
    var p = 0.017453292519943295;
    var c = angularMath.cosNumber;
    var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * angularMath.asinNumber(angularMath.squareOfNumber(a));
  }

}
