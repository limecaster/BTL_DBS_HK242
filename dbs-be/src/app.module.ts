import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { msSqlConfig } from 'config/ms-sql.config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CakeModule } from './cake/cake.module';

@Module({
  imports: [TypeOrmModule.forRoot(msSqlConfig), CakeModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
