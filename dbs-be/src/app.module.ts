import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { msSqlConfig } from 'config/ms-sql.config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CakeModule } from './cake/cake.module';
import { IngredientModule } from './ingredient/ingredient.module';
import { CakehasingredientModule } from './cakehasingredient/cakehasingredient.module';
import { ComboCakeModule } from './combo-cake/combo-cake.module';

@Module({
  imports: [TypeOrmModule.forRoot(msSqlConfig), CakeModule, IngredientModule, CakehasingredientModule, ComboCakeModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
