import { PartialType } from '@nestjs/mapped-types';
import { CreateCakehasingredientDto } from './create-cakehasingredient.dto';

export class UpdateCakehasingredientDto extends PartialType(CreateCakehasingredientDto) {}
