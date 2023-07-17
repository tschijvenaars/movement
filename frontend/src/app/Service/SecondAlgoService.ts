import { Injectable } from "@angular/core";
import { angularMath } from "angular-ts-math";
import { LatLonDTO } from "../Models/DTOs/LatLongDTO";
import { SecondAlgoDTO } from "../Models/DTOs/SecondAlgoDTO";
import { TrackedLocationDTO } from "../Models/DTOs/TrackedLocationDTO";
import { TrackedMovementDTO } from "../Models/DTOs/TrackedMovementDTO";
import { AlgoService } from "./AlgoService";

@Injectable({ providedIn: 'root' })
export class SecondAlgoService {
    calculateMovement(rawList: LatLonDTO[]): SecondAlgoDTO {
        var points = new SecondAlgoDTO();
        points.correctPoints = rawList;
        points.incorrectPoints = this.filterNoise(rawList);
        let result = this.filterLocations(rawList);
        points.locations = result.locations;
        points.movements = result.movements;

        return points;
    }

    filterNoise(rawList: LatLonDTO[]): LatLonDTO[] {
        let incorrectPoints: LatLonDTO[] = [];
        let pointsCache: LatLonDTO[] = [];
        let totalDistance = 0;

        for (let i = 0; i < rawList.length; i++) {
            if (pointsCache.length == 30) {

                // console.log("totalDistance: " + totalDistance);
                // console.log("averageDistance: " + totalDistance / 30);
                totalDistance = 0;
                pointsCache = [];
            } else {

                if (pointsCache.length > 0) {
                    totalDistance += this.calculateDistance(pointsCache[pointsCache.length - 1].Lat, pointsCache[pointsCache.length - 1].Lon, rawList[i].Lat, rawList[i].Lon);
                }

                pointsCache.push(rawList[i]);

            }
        }

        return [];
    }

    filterLocations(rawList: LatLonDTO[]): SecondAlgoDTO {
        let results = new SecondAlgoDTO();
        results.locations = [];
        results.movements = [];
        let lastLocationIndex = 0;
        let lastMovingIndex = 0;
        let minDistance = 0.2;
        let minTime = 5 * 60 * 1000
        let timeNotMoving = 0;
        let isMoving = false;
        let medianList: number[] = [];


        for (let i = 1; i < rawList.length; i++) {

            if (isMoving) {
                //stop detectie


                if (lastMovingIndex + 10 < i) {
                    medianList = [];

                    for (let j = lastMovingIndex; j < rawList.length; j++) {
                        let distance = this.calculateDistance(rawList[j].Lat, rawList[j].Lon, rawList[j - 1].Lat, rawList[j - 1].Lon);
                        medianList.push(distance)
                    }

                    let mediumDistance = this.getMedian(medianList);

                    if (mediumDistance < 0.05) {
                        var timeDifference = rawList[i].Date - rawList[i - 1].Date;
                        timeNotMoving += timeDifference;

                    } else {
                        timeNotMoving = 0;
                    }

                    if (timeNotMoving > minTime) {
                        //phone stopped moving
                        let movement = new TrackedMovementDTO();
                        movement.TrackedLatLons = [];
                        let timeDifference = 0;
                        let averagePoints: number = 0;
                        let totalLat: number = 0;
                        let totalLon: number = 0;

                        for (let m = lastLocationIndex; m < i; m++) {
                            if (lastLocationIndex == 0) {
                                continue;
                            }

                            if ((i - 2) == m) {
                                let latlong = new LatLonDTO();
                                latlong.Lat = rawList[m].Lat;
                                latlong.Lon = rawList[m].Lon;
                                console.log("reached.");
                                movement.TrackedLatLons.push(latlong);
                            }

                            let startBearing = this.bearing(rawList[m - 1].Lat, rawList[m - 1].Lon, rawList[m].Lat, rawList[m].Lon);
                            let endBearing = this.bearing(rawList[m + 1].Lat, rawList[m + 1].Lon, rawList[m].Lat, rawList[m].Lon);
                            let bearing = startBearing - endBearing
                            console.log("bearing: " + bearing);

                            timeDifference += rawList[m].Date - rawList[m - 1].Date;

                            if (bearing < 50 && bearing > -50) {
                                averagePoints++;
                                totalLat += rawList[m].Lat;
                                totalLon += rawList[m].Lon;


                                console.log(timeDifference);
                                if (timeDifference > 30 * 1000) {
                                    let latlong = new LatLonDTO();
                                    latlong.Lat = totalLat / averagePoints;
                                    latlong.Lon = totalLon / averagePoints;
                                    latlong.startBearing = startBearing;
                                    latlong.endBearing = endBearing;
                                    movement.TrackedLatLons.push(latlong);

                                    timeDifference = 0;
                                    totalLat = 0;
                                    totalLon = 0;
                                    averagePoints = 0;
                                }


                            }

                        }



                        results.movements.push(movement);
                        isMoving = false;
                        lastLocationIndex = i;
                    }

                    lastMovingIndex = i;
                }



            } else {
                let distance = this.calculateDistance(rawList[lastLocationIndex].Lat, rawList[lastLocationIndex].Lon, rawList[i].Lat, rawList[i].Lon);

                //verplaatsing detectie
                if (distance > minDistance) {
                    //phone started moving
                    isMoving = true;
                    timeNotMoving = 0;
                    lastMovingIndex = i;
                    //current index is a new location
                    //TODO:: store location
                    let location = new TrackedLocationDTO();
                    location.Lat = rawList[lastLocationIndex].Lat;
                    location.Lon = rawList[lastLocationIndex].Lon;

                    results.locations.push(location);
                }
            }
        }

        return results;
    }

    getMedian(arr: number[]) {
        const mid = Math.floor(arr.length / 2),
            nums = [...arr].sort((a, b) => a - b);
        return arr.length % 2 !== 0 ? nums[mid] : (nums[mid - 1] + nums[mid]) / 2;
    };

    calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var c = angularMath.cosNumber;
        var a = 0.5 -
            c((lat2 - lat1) * p) / 2 +
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

        return 12742 * angularMath.asinNumber(angularMath.squareOfNumber(a));
    }

    // Converts from degrees to radians.
    toRadians(degrees) {
        return degrees * Math.PI / 180;
    };

    // Converts from radians to degrees.
    toDegrees(radians) {
        return radians * 180 / Math.PI;
    }


    bearing(startLat, startLng, destLat, destLng) {
        startLat = this.toRadians(startLat);
        startLng = this.toRadians(startLng);
        destLat = this.toRadians(destLat);
        destLng = this.toRadians(destLng);

        let y = Math.sin(destLng - startLng) * Math.cos(destLat);
        let x = Math.cos(startLat) * Math.sin(destLat) -
            Math.sin(startLat) * Math.cos(destLat) * Math.cos(destLng - startLng);
        let brng = Math.atan2(y, x);
        brng = this.toDegrees(brng);
        return (brng + 360) % 360;
    }
}