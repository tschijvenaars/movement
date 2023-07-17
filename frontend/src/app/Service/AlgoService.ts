import { LatLonDTO } from "../Models/DTOs/LatLongDTO";
import { TrackedLocationDTO } from "../Models/DTOs/TrackedLocationDTO";

export interface AlgoService {
 calculateMovement(rawList: LatLonDTO[]) : TrackedLocationDTO[]; 
}