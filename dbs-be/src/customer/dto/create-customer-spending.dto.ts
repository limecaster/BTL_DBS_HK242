// create-customer-spending.dto.ts
import { IsInt, Min, Max, IsNotEmpty, IsIn } from 'class-validator';

export class CreateCustomerSpendingDto {
  @IsNotEmpty({ message: 'month must not be empty' })
  @IsInt({message: 'month must be an integer'})
  month: number;

  @IsNotEmpty({ message: 'year must not be empty' })
  
  year: number;
}
