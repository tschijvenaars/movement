import { TrackedMovementDTO } from "./TrackedMovementDTO";

export class TrackedLocationDTO {
    Lat: number;
    Lon: number;
    StartTime: number;
    EndTime: number;
    Name: string;
    Reason: string;
    TrackedMovements: TrackedMovementDTO[];
}