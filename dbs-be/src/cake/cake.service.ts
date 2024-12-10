import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCakeDto } from './dto/create-cake.dto';
import { UpdateCakeDto } from './dto/update-cake.dto';
import { DataSource } from 'typeorm';
import { filter } from 'rxjs';


@Injectable()
export class CakeService {
  constructor(private readonly dataSource: DataSource) {}

  //5a
  async create(createCakeDto: CreateCakeDto): Promise<any> {
    try{
    const query = `
      EXEC InsertCake 
        @Name = '${createCakeDto.name}', 
        @Price = ${createCakeDto.price}, 
        @IsSalty = ${createCakeDto.isSalty}, 
        @IsSweet = ${createCakeDto.isSweet}, 
        @IsOther = ${createCakeDto.isOther}, 
        @IsOrder = ${createCakeDto.isOrder}, 
        @CustomerNote = '${createCakeDto.customerNote || null}', 
        @Status = ${createCakeDto.status || 1}
    `;
  
      // Thực thi câu lệnh trực tiếp
      const result = await this.dataSource.query(query);
      return {
        message: result[0]?.Message,
      };
    }
    catch (error) {
      return {
        message : error.message
      }
    }
  }
  
  

  async findAll(
    page: number = 1,
    limit: number = 10,
    search: string =''
  ): Promise<any> {
    const query = 
    `
      EXEC GetAllCakes @Page = ${page}, @Limit = ${limit}, @Search = '${search}'
    `;
    const queryPage =
    `
      EXEC CALCULATEPAGE @Search = '${search}'
    `
    const result = await this.dataSource.query(query);
    const resultTotal = await this.dataSource.query(queryPage)

    const total = resultTotal[0]?.Total || 0;
    const totalPages = Math.ceil(total/limit);
    
    // console.log(result);
    // console.log(total);
    
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

  async findOne(id: number): Promise<any> {
    const query = 'SELECT * FROM Cake WHERE ID = @0 AND Status = 1';
    const result = await this.dataSource.query(query, [id]);
  
    if (!result.length) {
      throw new NotFoundException(`Cake with ID ${id} not found`);
    }
    return result[0];
  }

  async update(id: number, updateCakeDto: UpdateCakeDto): Promise<any> {
    const cake = await this.findOne(id);
    if (!cake) throw new NotFoundException(`Cake with ID ${id} not found`);

    const {
      name,
      price,
      isSalty,
      isSweet,
      isOther,
      isOrder,
      customerNote,
      status,
    } = updateCakeDto;

    const query = `
    EXEC UpdateCake
      @ID = @0,
      @Name = @1,
      @Price = @2,
      @IsSalty = @3,
      @IsSweet = @4,
      @IsOther = @5,
      @IsOrder = @6,
      @CustomerNote = @7,
      @Status = @8;
  `;    
  try {
    const result = await this.dataSource.query(query, [
      id,
      name || null,
      price || null,
      isSalty !== undefined ? (isSalty ? 1 : 0) : null,
      isSweet !== undefined ? (isSweet ? 1 : 0) : null,
      isOther !== undefined ? (isOther ? 1 : 0) : null,
      isOrder !== undefined ? (isOrder ? 1 : 0) : null,
      customerNote || null,
      status || null
    ]);
    const cakeResult = await this.findOne(id);

    return { message: result[0]?.Message,
             data: cakeResult
     };
    } catch (error) {
    throw new Error(`Failed to update cake: ${error.message}`);
    } 
  }

  async remove(id: number): Promise<any> {
    const cake = await this.findOne(id);
    if (!cake) throw new NotFoundException(`Cake with ID ${id} not found`);
    const query = `
      EXEC DeleteCake @ID = ${id}
    `;

    try {
      const result = await this.dataSource.query(query);
      return { message: result[0]?.Message};
    }
    catch(error){
      throw new Error(`Failed to delete cake: ${error.message}`);
    }
  }
  //5b
  async getTopCakes(startDate: string, endDate: string, top: number, search?: string, filterQuantity ?: number){
    try{
      
      const result = await this.dataSource.query(
        `EXEC GetTopCakes @StartDate = @0, @EndDate = @1, @Top = @2`,
        [startDate, endDate, top]
      );
      let filteredResults = result;

      //loc theo tim kiem
      if(search){
        const lowerSearch = search.toLowerCase();
        filteredResults = filteredResults.filter((cake) => cake.Name.toLowerCase().includes(lowerSearch))
      }

      // loc the filterQuantity (loc theo so luong banh lon hon so luong truyen vao)
      if(filterQuantity){
        filteredResults = filteredResults.filter(
          (cake) => (cake.TotalQuantity >= filterQuantity)
        )
      }

      return filteredResults;
    }
    catch(error){
      throw new BadRequestException(error.message)
    }
  }

}
