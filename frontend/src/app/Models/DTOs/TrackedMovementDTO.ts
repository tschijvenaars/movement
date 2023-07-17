import { LatLonDTO } from "./LatLongDTO";

export class TrackedMovementDTO  {
    TrackedLatLons: LatLonDTO[];
    StartTime: number;
    EndTime: number;
}