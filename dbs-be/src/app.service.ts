import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';

@Injectable()
export class AppService {
  constructor(@InjectDataSource() private readonly dataSource: any) {}
  getTest(): string {
    return this.dataSource.query('SELECT * FROM dbo.Cake');
  }
  getHello(): string {
    return 'Hello World!';
  }
}
