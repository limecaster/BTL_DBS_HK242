import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
} from '@nestjs/common';
import { CakeService } from './cake.service';
import { CreateCakeDto } from './dto/create-cake.dto';
import { UpdateCakeDto } from './dto/update-cake.dto';

@Controller('cake')
export class CakeController {
  constructor(private readonly cakeService: CakeService) {}

  @Post('create')
  async create(@Body() createCakeDto: CreateCakeDto) {
    return await this.cakeService.create(createCakeDto);
  }

  @Get('getAll')
  async findAll(@Query('page') page?: number, @Query('limit') limit?: number, @Query('search') search?: string) {
    const pageNumber = page && page > 0 ? page : 1;
    const limitNumber = limit && limit > 0 ? limit : 10;
    const searchText = search ? search.trim(): '';
    return await this.cakeService.findAll(pageNumber, limitNumber, searchText);
  }

  @Get('getOne/:id')
  findOne(@Param('id') id: string) {
    return this.cakeService.findOne(+id);
  }

  @Patch('update/:id')
  update(@Param('id') id: string, @Body() updateCakeDto: UpdateCakeDto) {
    return this.cakeService.update(+id, updateCakeDto);
  }

  @Delete('delete/:id')
  remove(@Param('id') id: string) {
    return this.cakeService.remove(+id);
  }
}
