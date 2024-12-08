import { Controller, Get, Post, Body, Patch, Param, Delete, Query } from '@nestjs/common';
import { IngredientService } from './ingredient.service';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';

@Controller('ingredient')
export class IngredientController {
  constructor(private readonly ingredientService: IngredientService) {}

  @Post('create')
  async create(@Body() createIngredientDto: CreateIngredientDto) {
    return await this.ingredientService.create(createIngredientDto);
  }

  @Get('getAll')
  async findAll(@Query('page') page?: number,@Query('limit') limit?: number,@Query('search') search?: string) {
    const pageNumber = page && page > 0 ? page : 1;
    const limitNumber = limit && limit > 0 ? limit : 10;
    const searchText = search ? search.trim(): '';
    return await this.ingredientService.findAll(pageNumber, limitNumber, searchText);
  }

  
  @Get('getOne/:id')
  async findOne(@Param('id') id: string) {
    return await this.ingredientService.findOne(+id);
  }

  @Patch('update/:id')
  async update(@Param('id') id: string, @Body() updateIngredientDto: UpdateIngredientDto) {
    return await this.ingredientService.update(+id, updateIngredientDto);
  }

  @Delete('delete/:id')
  async remove(@Param('id') id: string) {
    return await this.ingredientService.remove(+id);
  }
}
