import { state } from "@angular/animations";
import { ThrowStmt } from "@angular/compiler";
import { Injectable } from "@angular/core";
import { angularMath } from "angular-ts-math";
import { CurrentStateDTO } from "../Models/DTOs/CurrentStateDTO";
import { LatLonDTO } from "../Models/DTOs/LatLongDTO";
import { LocationDTO } from "../Models/DTOs/LocationDTO";
import { TrackedLocationDTO } from "../Models/DTOs/TrackedLocationDTO";
import { TrackedMovementDTO } from "../Models/DTOs/TrackedMovementDTO";
import { AlgoService } from "./AlgoService";

@Injectable({ providedIn: 'root' })
export class SimpleAlgoService implements AlgoService {
    currentState: CurrentStateDTO;
    unKnownLocations: LocationDTO[] = [];
    trackedLocations: TrackedLocationDTO[] = [];

    calculateMovement(rawList: LatLonDTO[]): TrackedLocationDTO[] {
        console.log(rawList);
        for(let i = 0; i < rawList.length; i++) {
            var location = new LocationDTO();
            location.date = rawList[i].Date;
            location.lat = rawList[i].Lat;
            location.lon = rawList[i].Lon;
            this.calculatePotentialStop(location);
        }

        return this.trackedLocations;
    }

    getCurrentStateAsync() {
        if (this.currentState != null) {
            return this.currentState;
        }


        this.currentState = new CurrentStateDTO();
        this.currentState.isMoving = false;
        this.currentState.potentialLocation = 0;
        this.currentState.potentialVehicle = 0;
        this.currentState.distanceTraveled = 0;
        this.currentState.timePassed = 0;

        return this.currentState;
    }

    checkIfStartedMoving(minDistance: number) {
        if (this.currentState.distanceTraveled > minDistance && !this.currentState.isMoving) {
            this.currentState.isMoving = true;
            this.currentState.timePassed = 0;

            var trackedLocation = new TrackedLocationDTO();
            trackedLocation.StartTime = this.unKnownLocations[0].date;
            trackedLocation.EndTime = this.unKnownLocations[this.unKnownLocations.length - 1].date
            trackedLocation.Lat = this.unKnownLocations[this.unKnownLocations.length - 1].lat;
            trackedLocation.Lon = this.unKnownLocations[this.unKnownLocations.length - 1].lon;
            trackedLocation.TrackedMovements = [];
            this.unKnownLocations = [];
            this.trackedLocations.push(trackedLocation);
        }
    }

    checkIfStopMoving(minTime: number) {
        if(this.currentState.isMoving && this.currentState.timePassed > minTime) {
            this.currentState.isMoving = false;
            this.currentState.timePassed = 0;
            this.currentState.distanceTraveled = 0;

            var trackedLocationIndex = this.trackedLocations.findIndex((tl) => tl.EndTime < this.unKnownLocations[0].date);

            var trackedMovement = new TrackedMovementDTO();
            trackedMovement.StartTime = this.unKnownLocations[0].date;
            trackedMovement.EndTime = this.unKnownLocations[this.unKnownLocations.length - 1].date;
            trackedMovement.TrackedLatLons = [];

            for(let i = 0; i < this.unKnownLocations.length; i++) {
                var latlon = new LatLonDTO();
                latlon.Date = this.unKnownLocations[i].date;
                latlon.Lat = this.unKnownLocations[i].lat;
                latlon.Lon = this.unKnownLocations[i].lon;

                trackedMovement.TrackedLatLons.push(latlon);
            }

            this.trackedLocations[trackedLocationIndex].TrackedMovements.push(trackedMovement);
            this.unKnownLocations = [];

        }
    }

    getUnknownLocations() {
        return this.unKnownLocations;
    }

    getLastLocation(): LocationDTO {
        if(this.unKnownLocations.length == 0) {
            return null;
        }

        return this.unKnownLocations[this.unKnownLocations.length - 1];
    }

    calculatePotentialStop(location: LocationDTO) {
      //  var maxTime = 40 * 60 * 1000;
        var minTime = 10 * 60 * 1000;
        var minDistance = 0.050;

        var lastLocation = this.getLastLocation();
        if(lastLocation == null) {
            this.unKnownLocations.push(location);
            return;
        }

        this.unKnownLocations.push(location);

        var currentState = this.getCurrentStateAsync();
        var timeDifference = location.date - lastLocation.date;
        var distanceDifference = this.calculateDistance(location.lat, location.lon, lastLocation.lat, lastLocation.lon)

        this.currentState.distanceTraveled = distanceDifference;
        this.currentState.timePassed = distanceDifference > 0.01 ? 0 : currentState.timePassed + timeDifference;

        this.checkIfStartedMoving(minDistance);
        this.checkIfStopMoving(minTime);
    }

    calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var c = angularMath.cosNumber;
        var a = 0.5 -
            c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

        return 12742 * angularMath.asinNumber(angularMath.squareOfNumber(a));
    }
}