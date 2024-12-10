import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { ComboCakeService } from './combo-cake.service';
import { CreateComboCakeDto } from './dto/create-combo-cake.dto';
import { UpdateComboCakeDto } from './dto/update-combo-cake.dto';

@Controller('combo-cake')
export class ComboCakeController {
  constructor(private readonly comboCakeService: ComboCakeService) {}

  @Post('create')
  async create(@Body() createComboCakeDto: CreateComboCakeDto) {
    return await this.comboCakeService.create(createComboCakeDto);
  }

  @Get('getAllCombo')
  async findAll() {
    return await this.comboCakeService.findAll();
  }

  @Get('getComboByCake/:id')
  async findOneComboByCake(@Param('id') id: string) {
    return await this.comboCakeService.findOneComboByCake(+id);
  }

  @Get('getComboCake/:cakeId1/:cakeId2')
  async findComboCake(@Param('cakeId1') cakeId1: string, @Param('cakeId2') cakeId2: string ){
    return await this.comboCakeService.findComboCake(+cakeId1,+cakeId2)
  }

  @Patch('update/:cakeId1/:cakeId2')
  async update(@Param('cakeId1') cakeId1: string, @Param('cakeId2') cakeId2: string,@Body() updateComboCakeDto: UpdateComboCakeDto) {
    return  await this.comboCakeService.update(+cakeId1, +cakeId2, updateComboCakeDto);
  }

  @Delete('delete/:cakeId1/:cakeId2')
  async remove(@Param('cakeId1') cakeId1: string, @Param('cakeId2') cakeId2: string) {
    return  await this.comboCakeService.remove(+cakeId1, +cakeId2);
  }
}
