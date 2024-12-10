import { Controller, Get, Post, Body, Patch, Param, Delete, Query } from '@nestjs/common';
import { CakehasingredientService } from './cakehasingredient.service';
import { CreateCakehasingredientDto } from './dto/create-cakehasingredient.dto';
import { UpdateCakehasingredientDto } from './dto/update-cakehasingredient.dto';

@Controller('cakehasingredient')
export class CakehasingredientController {
  constructor(private readonly cakehasingredientService: CakehasingredientService) {}

  @Post('create')
  async create(@Body() createCakehasingredientDto: CreateCakehasingredientDto) {
    return await this.cakehasingredientService.create(createCakehasingredientDto);
  }

  @Get('getAll')
  async findAll(){
    return await this.cakehasingredientService.findAll();
  }

  @Get('getAllIngredientOfCake/:id')
  async findAllIngredientOfCake(@Param('id') id: string) {
    return await this.cakehasingredientService.findAllIngredientOfCake(+id);
  }

  @Get('getOne/:cakeId/:ingredientId')
  async findOne(@Param('cakeId') cakeId: string, @Param('ingredientId') ingredientId: string) {
    return await this.cakehasingredientService.findOne(+cakeId, +ingredientId);
  }

  @Patch('update/:cakeId/:ingredientId')
  update(@Param('cakeId') cakeId: string, 
         @Param('ingredientId') ingredientId: string,
         @Body() updateCakehasingredientDto: UpdateCakehasingredientDto) {
    return this.cakehasingredientService.update(+cakeId,+ingredientId, updateCakehasingredientDto);
  }

  @Delete('delete/:cakeId/:ingredientId')
  async remove(@Param('cakeId') cakeId: string,@Param('ingredientId') ingredientId: string) {
    return await this.cakehasingredientService.remove(+cakeId, +ingredientId);
  }
}
