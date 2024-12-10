import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCakehasingredientDto } from './dto/create-cakehasingredient.dto';
import { UpdateCakehasingredientDto } from './dto/update-cakehasingredient.dto';
import { DataSource } from 'typeorm';

@Injectable()
export class CakehasingredientService {
  constructor(private readonly dataSource: DataSource){}

  async create(createCakehasingredientDto: CreateCakehasingredientDto) {
    const {cakeId, ingredientId, amount , unit , status} = createCakehasingredientDto;
    const query = 
    `
    EXEC InsertCakeHasIngredient 
      @CakeID = @0,
      @IngredientID = @1,
      @Amount = @2,
      @Unit = @3,
      @Status = @4
    `
    try {
      await this.dataSource.query(query,[
        cakeId,ingredientId,amount,unit,status
      ]);
      return {message: 'Relation created successfully'}
    }
    catch(error){
      throw new BadRequestException(error.message);
    }
  }

  async findAll() {
    const query = 'SELECT * FROM CakeHasIngredient WHERE Status = 1';
    return await this.dataSource.query(query);
  }

  async findAllIngredientOfCake(id: number) {
    const query = 
    `
      EXEC GetCakeHasIngredient 
        @CakeID = ${id}
    `;
    try{
      const result = await this.dataSource.query(query);
      if(!result.length) {
        throw new NotFoundException(`Cake with ID ${id} have no ingredient`)
      }
      return result
    }
    catch(error){
      throw new BadRequestException(error.message);
    }
    
  }

  async findOne(cakeId: number, ingredientId: number) {
    const query = `
      SELECT * FROM CakeHasIngredient
      WHERE CakeID = @0 AND IngredientID = @1 AND Status = 1
    `;
    
    const result = await this.dataSource.query(query, [cakeId, ingredientId]);

    if (!result.length) {
      throw new NotFoundException(
        `Relation between Cake ID (${cakeId}) and Ingredient ID (${ingredientId}) not found`,
      );
    }

    return result[0];
  }

  async update(cakeId: number, ingredientId: number,  updateCakehasingredientDto: UpdateCakehasingredientDto) {
    const {amount , unit, status } = updateCakehasingredientDto;
    const query = 
    `
    EXEC UpdateCakeHasIngredient
       @CakeID = @0, 
       @IngredientID = @1, 
       @Amount = @2, 
       @Unit = @3, 
       @Status = @4
    `;
    try {
      await this.dataSource.query(query, [
        cakeId, 
        ingredientId, 
        amount || null, 
        unit || null, 
        status || null
      ]);
      const result = await this.findOne(cakeId, ingredientId);
      return {
        message: 'Relation updated successfully',
        data: result
      }
    }
    catch(error){
      throw new BadRequestException(error.message);
    }
  }

  async remove(cakeId: number, ingredientId: number) {
    try {
      await this.dataSource.query(
        `EXEC DeleteCakeHasIngredient @CakeID = @0, @IngredientID = @1`,
        [cakeId, ingredientId],
      );
      return { message: 'Relation deleted successfully' };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}
