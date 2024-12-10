import { Module } from '@nestjs/common';
import { CakeService } from './cake.service';
import { CakeController } from './cake.controller';

@Module({
  controllers: [CakeController],
  providers: [CakeService],
})
export class CakeModule {}
