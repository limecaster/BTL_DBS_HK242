import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('Cake')
export class Cake {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'nvarchar', length: 255 })
  name: string;

  @Column({ type: 'money' })
  price: number;

  @Column({ type: 'bit', default: 0 })
  isSalty: boolean;

  @Column({ type: 'bit', default: 0 })
  isSweet: boolean;

  @Column({ type: 'bit', default: 0 })
  isOther: boolean;

  @Column({ type: 'bit', default: 0 })
  isOrder: boolean;

  @Column({ type: 'ntext', nullable: true })
  customerNote: string; // Ghi chú của khách hàng (nullable)

  @Column({ type: 'int', default: 1 })
  status: number; // Trạng thái (int)
}
