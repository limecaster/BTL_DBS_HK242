import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class CustomerService {
  constructor(private readonly dataSource: DataSource){}

  async getTopSpenders(startDate: string | null, endDate: string | null)
  {
    try{
      const query =
      `
      SELECT TOP 5
	      C.Phone AS CustomerPhone,
        C.FirstName + ' ' + C.LastName  AS CustomerName,
        dbo.GetTotalMoneyPaidByCustomer(C.Phone, @0, @1) AS TotalMoneySpent
        FROM Customer C
        ORDER BY TotalMoneySpent DESC;
      `
      const result = await this.dataSource.query(query,[startDate,endDate]);

      const filter =  result.filter((customer) => customer.TotalMoneySpent > 0);
      if(!filter.length){
        throw new NotFoundException('Not found customer total money spent')
      }
      return filter;
    }
    catch(error){
      throw new BadRequestException(error.message);
    }
  }
  
  async getTopSpendersByMonth(month: number, year: number){
    const startDate = `${year}-${month}-01`;
    const endDate = new Date(year,month,0).toISOString().slice(0,10); //tinh ngay cuoi cung cua thang

    return await this.getTopSpenders(startDate, endDate)
  }
  
}
