import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { msSqlConfig } from 'config/ms-sql.config';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [TypeOrmModule.forRoot(msSqlConfig)],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
