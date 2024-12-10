import { IsIn, IsNotEmpty, IsNumber, IsOptional, IsPositive, IsString } from "class-validator"

export class CreateIngredientDto {
    @IsNotEmpty({message: 'Name must not be empty'})
    @IsString({message: 'Name must be a string'})
    name: string

    @IsNotEmpty({message: 'Price must not be empty'})
    @IsPositive({message: 'Price must be a positive number'})
    @IsNumber({}, {message: 'Price must be a number like money'})
    importPrice: number


    @IsOptional()
    @IsIn([0, 1], { message: 'Status must be 0 or 1' })
    status: number

}
