import { IsIn, IsInt, IsNotEmpty, IsNumber, IsOptional, IsPositive, IsString } from "class-validator";

export class CreateCakehasingredientDto {
    @IsNotEmpty({message: 'CakeID must not be empty'})
    @IsInt({ message: 'CakeID must be an integer' })
    cakeId: number

    
    @IsNotEmpty({message: 'IngredientID must not be empty'})
    @IsInt({ message: 'IngredientID must be an integer' })
    ingredientId: number

    @IsPositive({message: 'Amount must be a positive number'})
    @IsNumber({}, {message: 'Amount must be a number'})
    amount: number;

    @IsIn(['gram', 'kilogram', 'liter', 'milliliter', 'pound'], { 
        message: 'Unit must be one of the following: gram, kilogram, liter, milliliter, pound' 
    })
    unit: string
    

    @IsOptional()
    @IsIn([0, 1], { message: 'Status must be 0 or 1' })
    status: number
}

