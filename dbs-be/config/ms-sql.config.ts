import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import * as dotenv from 'dotenv';

dotenv.config();

export const msSqlConfig: TypeOrmModuleOptions = {
  type: 'mssql',
  host: process.env.DB_HOST as string,
  port: parseInt(process.env.DB_PORT, 10),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: false,
  options: {
    encrypt: false,
    enableArithAbort: true,
  },
};
