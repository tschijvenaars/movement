import { ObjectUnsubscribedErrorCtor } from "rxjs/internal/util/ObjectUnsubscribedError";
import { TrackedLocationDTO } from "./TrackedLocationDTO";
import { UserDTO } from "./UserDTO";

export class TrackedDayDTO {
    ChoiceId: number;
    Confirmed: boolean;
    CreatedAt: Date;
    Day: number;
    DeletedAt: Date;
    ID: number;
    Missing: number;
    TrackedDayId: number;
    TrackedLocations: TrackedLocationDTO[];
    Unvalidated: number;
    UpdatedAt: Date;
    User: UserDTO;
    UserId: number;
    Validated: number;
}