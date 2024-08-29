import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('events')  // Assuming your table name is 'events'
export class Event {
  @PrimaryGeneratedColumn('uuid')
  event_id: string;

  @Column()
  title: string;

  @Column()
  description: string;

  @Column('text')
  metadata: string;

  @Column({ type: 'timestamp' })
  created_at: Date;

  @Column({ type: 'timestamp' })
  start_date_time: Date;

  @Column({ type: 'timestamp' })
  end_date_time: Date;

  @Column('int')
  max_attendees: number;

  @Column({ default: false })
  is_private: boolean;

  @Column('uuid')
  venue_id: string;

  @Column('int')
  available_slots: number;
}
