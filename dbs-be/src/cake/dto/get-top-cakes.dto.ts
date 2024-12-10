import { IsDateString, IsInt, IsNumber, IsOptional, Min } from 'class-validator';

export class GetTopCakesDto {
  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsOptional()
  top?: number;

  @IsOptional()
  search?: string;

  @IsOptional()
  filterQuantity?: number
  
}