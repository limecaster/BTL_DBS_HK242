import { Module } from '@nestjs/common';
import { ComboCakeService } from './combo-cake.service';
import { ComboCakeController } from './combo-cake.controller';

@Module({
  controllers: [ComboCakeController],
  providers: [ComboCakeService],
})
export class ComboCakeModule {}
