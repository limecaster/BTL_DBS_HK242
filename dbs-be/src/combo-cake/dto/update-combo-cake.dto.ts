import { PartialType } from '@nestjs/mapped-types';
import { CreateComboCakeDto } from './create-combo-cake.dto';

export class UpdateComboCakeDto extends PartialType(CreateComboCakeDto) {}
