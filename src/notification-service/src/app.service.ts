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
      .select('notification_id, message, event_id, user_id, sent_at, seen_at, notification_types(name), events(description, is_private, title, location, max_attendees, start_date_time, end_date_time)')
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
      return {
        status: 'success',
        data: [],
        timestamp: new Date().toISOString(),
      };
    }

    return {
      status: 'success',
      data,
      timestamp: new Date().toISOString(),
    };

  }
}
