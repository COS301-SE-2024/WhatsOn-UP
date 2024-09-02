import { IsString, IsOptional, IsUUID, IsInt, IsBoolean, IsNotEmpty, IsDate } from 'class-validator';
import { Type } from 'class-transformer';

export class EventDto {
  @IsUUID()
  @IsOptional()
  eventId?: string;

  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsString()
  @IsOptional()
  metadata?: string;

  @Type(() => Date)
  @IsDate()
  @IsNotEmpty()
  startDateTime: Date;

  @Type(() => Date)
  @IsDate()
  @IsNotEmpty()
  endDateTime: Date;

  @IsInt()
  @IsNotEmpty()
  maxAttendees: number;

  @IsBoolean()
  @IsOptional()
  isPrivate?: boolean;

  @IsUUID()
  @IsNotEmpty()
  venueId: string;

  @IsInt()
  @IsOptional()
  availableSlots?: number;
}
