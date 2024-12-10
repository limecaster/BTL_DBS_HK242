import { Controller, Get, Post, Body, Patch, Param, Delete, Query, BadRequestException, BadGatewayException } from '@nestjs/common';
import { CustomerService } from './customer.service';
import { CreateCustomerSpendingDto } from './dto/create-customer-spending.dto';


@Controller('customer')
export class CustomerController {
  constructor(private readonly customerService: CustomerService) {}

 @Get('top5-spenders')
 async getTopSpenders(
  @Query('startDate') startDate: string,
  @Query('endDate') endDate : string
 ){
  return await this.customerService.getTopSpenders(startDate, endDate)
 }


 @Get('top5-spenders-byMonth')
 async getTopSpendersByMonth(
  @Query('month') month: number,
  @Query('year') year: number
 ){
  if(!month || !year){
    throw new BadGatewayException('Month and year are require');
  }
  if(month < 1 || month > 12){
    throw new BadGatewayException('Month is between 1 and 12');
  }
  return await this.customerService.getTopSpendersByMonth(month, year)
 }
}
