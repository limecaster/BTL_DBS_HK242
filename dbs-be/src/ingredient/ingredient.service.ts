import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';
import { DataSource } from 'typeorm';

@Injectable()
export class IngredientService {
  constructor(private readonly dataSource: DataSource) {}

  async create(createIngredientDto: CreateIngredientDto) {
    const query = `
      EXEC InsertIngredient
      @Name = '${createIngredientDto.name}',
      @ImportPrice = ${createIngredientDto.importPrice},
      @Status = ${createIngredientDto.status || 1}
    `;
    return this.executeQuery(query);
  }

  async findAll(page: number = 1, limit: number = 10, search: string = '') {
    const query = `
      EXEC GetAllIngredient
        @Page = ${page},
        @Limit = ${limit},
        @Search = '${search}'
    `;
    const queryPage = `
      EXEC CALCULATEPAGEINGRE
        @Search = '${search}'
    `;
    const result = await this.dataSource.query(query);
    const resultTotal = await this.dataSource.query(queryPage);

    const total = resultTotal[0]?.Total || 0;
    const totalPages = Math.ceil(total / limit);
    return {
      result,
      meta: {
        total,
        page,
        limit,
        totalPages,
      },
    };
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
    await this.findOne(id);
    const { name, importPrice, status } = updateIngredientDto;
    const query = `
      EXEC UpdateIngredient
        @ID = @0,
        @Name = @1,
        @ImportPrice = @2,
        @Status = @3
    `;
    const result = await this.executeQuery(query, [id, name, importPrice, status]);
    const updatedIngredient = await this.findOne(id);
    return {
      message: result.message,
      data: updatedIngredient,
    };
  }

  async remove(id: number) {
    await this.findOne(id);
    const query = `
      EXEC DeleteIngredient 
        @ID = ${id}
    `;
    return this.executeQuery(query);
  }

  private async executeQuery(query: string, parameters: any[] = []) {
    try {
      const result = await this.dataSource.query(query, parameters);
      return {
        message: result[0]?.Message,
      };
    } catch (error) {
      throw new Error(`Database query failed: ${error.message}`);
    }
  }
}
