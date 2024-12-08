import { 
    IsInt, 
    IsNotEmpty, 
    IsPositive, 
    IsNumber, 
    IsOptional, 
    IsIn 
  } from 'class-validator';
  
  export class CreateComboCakeDto {
    @IsNotEmpty({ message: 'CakeID1 must not be empty' })
    @IsInt({ message: 'CakeID1 must be an integer' })
    @IsPositive({ message: 'CakeID1 must be a positive integer' })
    cakeId1: number;
  
    @IsNotEmpty({ message: 'CakeID2 must not be empty' })
    @IsInt({ message: 'CakeID2 must be an integer' })
    @IsPositive({ message: 'CakeID2 must be a positive integer' })
    cakeId2: number;
  
    @IsNotEmpty({ message: 'Price must not be empty' })
    @IsNumber({}, { message: 'Price must be a number' })
    @IsPositive({ message: 'Price must be a positive number' })
    price: number;
  
    @IsOptional()
    @IsIn([0, 1], { message: 'Status must be 0 (inactive) or 1 (active)' })
    status?: number;
  }
  