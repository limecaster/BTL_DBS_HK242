import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';
import { DataSource } from 'typeorm';

@Injectable()
export class IngredientService {
  constructor(private readonly dataSource: DataSource){}

  async create(createIngredientDto: CreateIngredientDto) {
    try{
      const query = 
      `
        EXEC InsertIngredient
          @Name = '${createIngredientDto.name}',
          @ImportPrice = ${createIngredientDto.importPrice},
          @Status = ${createIngredientDto.status || 1}
      `;
      const result = await this.dataSource.query(query);
      return{
        message: result[0]?.Message
      }
    }
    catch(error){
      return{
        message: error.message
      }
    }
  }

  async findAll(page: number = 1, limit: number = 10, search: string ='') {
        const query = 
       `
        EXEC GetAllIngredient
          @Page = ${page},
          @Limit = ${limit},
          @Search = '${search}'
        `;
        const queryPage =
        `
        EXEC CALCULATEPAGEINGRE
          @Search = '${search}'
        `
        const result = await this.dataSource.query(query);
        const resultTotal = await this.dataSource.query(queryPage);

        console.log(result);
        const total = resultTotal[0]?.Total || 0;
        const totalPages = Math.ceil(total/limit);
        return {
          result,
          meta: {
            total, 
            page,
            limit,
            totalPages
        }
    }
  }  


  async findOne(id: number) {
    const query = 'SELECT * FROM Ingredient WHERE ID = @0 AND Status = 1';
    const result = await this.dataSource.query(query, [id]);
  
    if (!result.length) {
      throw new NotFoundException(`Ingredient with ID ${id} not found`);
    }
    return result[0];
  }

  async update(id: number, updateIngredientDto: UpdateIngredientDto) {
    const ingredient = await this.findOne(id);
    if(!ingredient) throw new NotFoundException('Ingredient is not found');
    const {
      name,
      importPrice,
      status
    } = updateIngredientDto
    const query = 
        `
        EXEC UpdateIngredient
          @ID = @0,
          @Name = @1,
          @ImportPrice = @2,
          @Status = @3
        `
      try{
        const result = await this.dataSource.query(query,[
          id,
          name || null,
          importPrice || null,
          status || null
        ]);
        const resultIngre = await this.findOne(id);
        return {
          message: result[0]?.Message,
          data: resultIngre
        }

      }
      catch(error){
        throw new Error(`Failed to update ingredient: ${error.message}`);
      }
  }

  async remove(id: number) {
    const ingredient = await this.findOne(id);
    if(!ingredient) throw new NotFoundException('Ingredient not found');

    const query = 
    `
    EXEC DeleteIngredient 
      @ID = ${id}
    `;
    try{
    const result = await this.dataSource.query(query);
    return{
      message: result[0]?.Message,
    }
    }
    catch(error){
      throw new Error(`Failed to delete cake: ${error.message}`);
    }
  }
}
