import { Module } from '@nestjs/common';
import { CakehasingredientService } from './cakehasingredient.service';
import { CakehasingredientController } from './cakehasingredient.controller';

@Module({
  controllers: [CakehasingredientController],
  providers: [CakehasingredientService],
})
export class CakehasingredientModule {}
