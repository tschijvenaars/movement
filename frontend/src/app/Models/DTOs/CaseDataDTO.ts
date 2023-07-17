import { LatLonDTO } from "./LatLongDTO";
import { TrackedDayDTO } from "./TrackedDayDTO";
import { TrackedLocationDTO } from "./TrackedLocationDTO";

export class TestCaseDataDTO {
    Sdk: string;
    Day: number;
    Brand: string;
    RawData: LatLonDTO[];
    ValidatedData: TrackedDayDTO;
}