import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  BadRequestException,
} from '@nestjs/common';
import { CakeService } from './cake.service';
import { CreateCakeDto } from './dto/create-cake.dto';
import { UpdateCakeDto } from './dto/update-cake.dto';
import { GetTopCakesDto } from './dto/get-top-cakes.dto';

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

  @Get('getTopCake')
  async getTopCakes(@Query() query: GetTopCakesDto, 
                    @Query('top') top: number,
                    @Query('search') search?: string,
                    @Query('filterQuantity') filterQuantity?: number){
    const {startDate, endDate} = query;
    if(top < 1 ){
      throw new BadRequestException('Top must be greater than or equal to 1.')
    }
    if(!Number.isInteger(top)){
      throw new BadRequestException('Top must be an integer.');
    }
    if (new Date(startDate) > new Date(endDate)) {
      throw new BadRequestException('startDate cannot be greater than endDate.');
    }
    if (filterQuantity) {
      if (!Number.isInteger(Number(filterQuantity))) {
        throw new BadRequestException('filterQuantity must be a valid integer.');
      }
      if (Number(filterQuantity) < 0) {
        throw new BadRequestException('filterQuantity must be greater than or equal to 0.');
      }
    }
    return this.cakeService.getTopCakes(startDate,endDate,top, search, filterQuantity )
  }

  @Get('getTotalImportPrice')
  async getTotalImportPrice(@Query('minPrice') minPrice?: number) {
    console.log(minPrice);
    return await this.cakeService.getTotalImportPrice(minPrice);
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
