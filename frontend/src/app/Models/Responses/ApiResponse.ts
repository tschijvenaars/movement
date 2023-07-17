export class ApiResponse<T> {
    Body: T;
    InfoMessages: string[];
    ErrorMessages: string[];
    DebugMessages: string[];
  }
  
  