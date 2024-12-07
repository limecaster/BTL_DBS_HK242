import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateCakeDto } from './dto/create-cake.dto';
import { UpdateCakeDto } from './dto/update-cake.dto';
import { DataSource } from 'typeorm';


@Injectable()
export class CakeService {
  constructor(private readonly dataSource: DataSource) {}

  async create(createCakeDto: CreateCakeDto): Promise<any> {
    const queryRunner = this.dataSource.createQueryRunner();
  
    await queryRunner.connect();
    await queryRunner.startTransaction();
  
    try {
      const query = `
        INSERT INTO CAKE (Name, Price, IsSalty, IsSweet, IsOther, IsOrder, CustomerNote, Status)
        VALUES (@0, @1, @2, @3, @4, @5, @6, @7)
      `;
      const params = [
        createCakeDto.name,
        createCakeDto.price,
        createCakeDto.isSalty,
        createCakeDto.isSweet,
        createCakeDto.isOther,
        createCakeDto.isOrder,
        createCakeDto.customerNote || null,
        createCakeDto.status,
      ];
      await queryRunner.query(query, params);
  
      await queryRunner.commitTransaction();
      
      return { message: 'Create cake successful' };
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
  

  async findAll(
    page: number = 1,
    limit: number = 10,
    search: string =''
  ): Promise<any> {
    const offset = (page - 1) * limit;

    const query = 
    ` SELECT * 
      FROM Cake 
      WHERE Name LIKE @0
      ORDER BY ID
      OFFSET @1 ROWS FETCH NEXT @2 ROWS ONLY
    `
    ;
    const result = await this.dataSource.query(query, [`%${search}%`, offset, limit])

    //tinh tong ban Ghi
    const countQuerry = 
    ` SELECT COUNT(*) as total 
      FROM Cake 
      WHERE Name LIKE @0
    `
    const countResult = await this.dataSource.query(countQuerry,[`%${search}%`]);
    const total = countResult[0]?.total || 0;

    return {
      data: result,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total/limit)
      }
    }
  }

  async findOne(id: number): Promise<any> {
    const query = 'SELECT * FROM Cake WHERE ID = @0';
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

    // Khởi tạo mảng các trường sẽ được cập nhật
    const setClauses: string[] = [];
    if (name !== undefined) {
      setClauses.push(`Name = '${name}'`);
    }
    if (price !== undefined) {
      setClauses.push(`Price = ${price}`);
    }
    if (isSalty !== undefined) {
      setClauses.push(`IsSalty = ${isSalty ? 1 : 0}`);
    }
    if (isSweet !== undefined) {
      setClauses.push(`IsSweet = ${isSweet ? 1 : 0} `);
    }
    if (isOther !== undefined) {
      setClauses.push(`IsOther = ${isOther ? 1 : 0}`);
    }
    if (isOrder !== undefined) {
      setClauses.push(`IsOrder = ${isOrder ? 1 : 0}`);
    }
    if (customerNote !== undefined) {
      setClauses.push(`CustomerNote = '${customerNote}'`);
    }
    if (status !== undefined) {
      setClauses.push(`Status = ${status}`);
    }

    // Tạo câu lệnh SQL để cập nhật, chỉ cập nhật các trường có giá trị trong `setClauses`
    const query = `
      UPDATE Cake
      SET ${setClauses.join(', ')}
      WHERE ID = ${id};
    `;

    try {
      // Thực thi truy vấn
      await this.dataSource.query(query);
      const cakeUpdate = await this.findOne(id);

      return { message: 'Cake updated successfully', data: cakeUpdate };
    } catch (error) {
      throw new Error(`Failed to update cake: ${error.message}`);
    }
  }

  async remove(id: number): Promise<any> {
    const cake = await this.findOne(id);
    if (!cake) throw new NotFoundException(`Cake with ID ${id} not found`);
    const query = `DELETE FROM Cake WHERE ID = @0`;
    await this.dataSource.query(query, [id]);

    return {
      message: 'Delete cake successful',
    };
  }
}
