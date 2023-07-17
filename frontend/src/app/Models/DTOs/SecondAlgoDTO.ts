import { LatLonDTO } from "./LatLongDTO";
import { LocationDTO } from "./LocationDTO";
import { TrackedLocationDTO } from "./TrackedLocationDTO";
import { TrackedMovementDTO } from "./TrackedMovementDTO";

export class SecondAlgoDTO {
    correctPoints: LatLonDTO[];
    incorrectPoints: LatLonDTO[];
    locations: TrackedLocationDTO[];
    movements: TrackedMovementDTO[];
}