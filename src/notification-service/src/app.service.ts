import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { createClient } from '@supabase/supabase-js';

@Injectable()
export class AppService {
  private supabase;

  constructor() {
    this.supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_KEY
    );
  }

  async getNotifications(user_id: string) {
    const { data, error } = await this.supabase
      .from('notifications')
      .select('*')
      .eq('user_id', user_id);

    if (error) {
      console.error('Error fetching notifications:', error);
      throw new HttpException(
        {
          status: 'error',
          message: 'Error fetching notifications',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    if (!data || data.length === 0) {
      throw new HttpException(
        {
          status: 'error',
          message: 'No notifications found for user',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.NOT_FOUND,
      );
    }

    for (let notification of data) {
      const type: number = notification.type;

      let { data: typeData, error: typeError } = await this.supabase
        .from('notification_types')
        .select('name')
        .eq('type_id', type);

      if (typeError) {
        console.error('Error fetching notification type:', typeError);
        continue;
      }

      if (typeData && typeData.length > 0) {
        notification.type = typeData[0].name;
      }

      let { data: eventData, error: eventError } = await this.supabase
        .from('events')
        .select(
          'description, is_private, title, location, max_attendees, start_date_time, end_date_time'
        )
        .eq('event_id', notification.event_id);

      if (eventError) {
        console.error('Error fetching event:', eventError);
        continue;
      }

      if (eventData && eventData.length > 0) {
        notification.event = eventData[0];
      }
    }

    return {
      status: 'success',
      data,
      timestamp: new Date().toISOString(),
    };
  }
}
