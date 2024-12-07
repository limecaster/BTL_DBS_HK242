import {
    IsBoolean,
    IsIn,
    IsNumber,
    IsOptional,
    IsPositive,
    IsString,
  } from 'class-validator';
  
  export class CreateCakeDto {
    @IsString({message: 'Name must be a string'})
    name: string;
  
    @IsPositive({message: 'Price must be a positive number'})
    @IsNumber({}, {message: 'Price must be a number like money'})
    price: number;
  
    @IsBoolean({message: 'IsSalty muse be a boolean'})
    isSalty: boolean;
  
    @IsBoolean({message: 'IsSweet muse be a boolean'})
    isSweet: boolean;
  
    @IsBoolean({message: 'IsOther muse be a boolean'})
    isOther: boolean;
  
    @IsBoolean({message: 'IsOrder muse be a boolean'})
    isOrder: boolean;
  
    @IsOptional()
    @IsString()
    customerNote?: string;
  
    @IsIn([0, 1], { message: 'Status must be 0 or 1' })
    status: number;
  }
  