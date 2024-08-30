import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { createClient } from '@supabase/supabase-js';

@Injectable()
export class AppService {
  async deleteNotifications(userId: string): Promise<any> {
    const { data, error } = await this.supabase
      .from('notifications')
      .delete()
      .eq('user_id', userId);

    if (error) {
      console.error('Error deleting notifications:', error);
      throw new HttpException(
        {
          status: 'error',
          message: 'Error deleting notifications',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
    
    return {
      status: 'success',
      message: 'Notifications deleted',
      timestamp: new Date().toISOString(),
    };


  }
  async deleteNotification(userId: string, notification_id: string): Promise<any> {
    const { data, error } = await this.supabase
      .from('notifications')
      .delete()
      .eq('notification_id', notification_id)
      .eq('user_id', userId);

    if (error) {
      console.error('Error deleting notification:', error);
      throw new HttpException(
        {
          status: 'error',
          message: 'Error deleting notification',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    console.log('Data:', data);

    return {
      status: 'success',
      message: 'Notification deleted',
      timestamp: new Date().toISOString(),
    };

  }
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
      .select('notification_id, message, event_id, user_id, sent_at, seen_at, notification_types(name), events(description, is_private, title, venues(name, buildings(location, name, access_type)), max_attendees, start_date_time, end_date_time), referenced_event')
      .eq('user_id', user_id)
      .order("sent_at", {ascending: false});

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
