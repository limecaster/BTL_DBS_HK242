import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateComboCakeDto } from './dto/create-combo-cake.dto';
import { UpdateComboCakeDto } from './dto/update-combo-cake.dto';
import { DataSource } from 'typeorm';

@Injectable()
export class ComboCakeService {
  constructor(private readonly dataSource: DataSource){}

  async create(createComboCakeDto: CreateComboCakeDto) {
    const {cakeId1, cakeId2, price , status } = createComboCakeDto;
    const query = 
    `
      EXEC InsertComboCake
        @CakeID1 = @0,
        @CakeID2 = @1, 
        @Price = @2,
        @Status = @3
    `;
    try{
      await this.dataSource.query(query,[
        cakeId1, 
        cakeId2, 
        price , 
        status
      ]);
      return {
        message: 'ComboCake created successfully'
      }
    }
    catch(error){
      throw new BadRequestException(error.message)
    }
  }

  async findAll() {
    const query = 
    `
    EXEC GetAllCombos
    `;
    const result = await this.dataSource.query(query);
    if(!result.length){
      throw new NotFoundException('No combo found')
    }
    return result;
  }

  async findOneComboByCake(id: number) {
    const query = 
    `
    EXEC GetCombosByCakeID
      @CakeID = ${id}
    `
    try{
      const result = await this.dataSource.query(query);
      if (!result.length) {
        throw new NotFoundException(
          `Cake ID (${id}) not found in combo`,
        );
      }
      return result;
    }
    catch(error){
      throw new BadRequestException(error.message)
    }
  }

  async findComboCake(cakeId1: number, cakeId2: number) {
    const query = `
      EXEC GetComboCake 
        @CakeID1 = @0, 
        @CakeID2 = @1
    `;
    try{
      const result =  await this.dataSource.query(query, [cakeId1 ,cakeId2]);
      if(!result.length){
        throw new NotFoundException('No combo found')
      }
      return result[0]
    }
    catch(error){
      throw new BadRequestException(error.message)
    }
    
  }
  

  async update(cakeId1: number, cakeId2: number , updateComboCakeDto: UpdateComboCakeDto) {
    const {price, status} = updateComboCakeDto
    const query = 
    `
     EXEC UpdateComboCake 
      @CakeID1 = @0, 
      @CakeID2 = @1, 
      @Price = @2, 
      @Status = @3
    `
    try{
      const result = await this.dataSource.query(query, [
        cakeId1,
        cakeId2,
        price || null,
        status || null
      ]);
      const comboCake = await this.findComboCake(cakeId1,cakeId2);
      return {
        message: "ComboCake updated successfully.",
        data: comboCake
      }

    }
    catch(error){
      throw new BadRequestException(error.message)
    }
  }

  async remove(cakeId1: number, cakeId2: number) {
    const query = 
    `
    EXEC DeleteComboCake
      @CakeID1 = ${cakeId1},
      @CakeID2 = ${cakeId2}
    `;
    try{
      await this.dataSource.query(query);
      return {
        message: 'ComboCake deleted successfully'
      }
    }
    catch(error){
      throw new BadRequestException(error.message)
    }
  }
}
