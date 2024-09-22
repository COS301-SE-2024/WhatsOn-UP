import { OnModuleInit, UnauthorizedException, HttpException, HttpStatus } from '@nestjs/common';
import {
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server } from 'socket.io';
import { createClient } from '@supabase/supabase-js';
import { request } from 'http';
import { JwtService } from '@nestjs/jwt';

@WebSocketGateway(8082)
export class NotificationGateway implements OnModuleInit {
  @WebSocketServer()
  server: Server;

  clients: Record<string, { socket: any; token: string }> = {};

  private supabase;
  private jwtService: JwtService;

  constructor() {
    this.supabase = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_KEY
    );
    this.setupEventListener();
    this.jwtService = new JwtService();
  }

  private async setupEventListener() {
    const channel = this.supabase
      .channel('notifications')
      .on(
        'postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'notifications' },
        async (payload) => {
          let notification: any = payload.new;
          const type: number = notification.type;

          let { data: typeData, error: typeError } = await this.supabase
            .from('notification_types')
            .select('name')
            .eq('type_id', type);

          if (typeError) {
            console.error('Error fetching notification type:', typeError);
            this.emitError(notification.user_id, 'Error fetching notification type');
            return;
          }

          if (typeData && typeData.length > 0) {
            notification['notification_types'] = {
              name : typeData[0].name
            };
          }

          const client = Object.values(this.clients).find(
            (client) => client.token == notification.user_id
          );


          if (!client) {
            console.error('Client not found:', notification.user_id);
            this.emitError(notification.user_id, 'Client not found');
            return;
          }

          if (!notification.event_id) {
            client.socket.emit('notification', {
              status: 'success',
              data: notification,
              timestamp: new Date().toISOString(),
            });
            return;
          }


          let { data: eventData, error: eventError } = await this.supabase
            .from('events')
            .select(
              'description, is_private, title, max_attendees, start_date_time, end_date_time, venues(name, buildings(location, name, access_type))'
            )
            .eq('event_id', notification.event_id);

          if (eventError) {
            console.error('Error fetching event:', eventError);
            this.emitError(notification.user_id, 'Error fetching event');
            return;
          }

          if (eventData && eventData.length > 0) {
            notification['events'] = eventData[0];
          } else {
            this.emitError(notification.user_id, 'Event not found');
            return;
          }
          
          notification['event_invitees'] = { accepted: null};

          if (client) {
            client.socket.emit('notification', {
              status: 'success',
              data: notification,
              timestamp: new Date().toISOString(),
            });
          }
        }
      )
      .subscribe();

    channel.on('subscribe', (status) => {
      console.log('Subscription status:', status);
    });

    channel.on('error', (error) => {
      console.error('Subscription error:', error);
    });
  }

  onModuleInit() {
    this.server.on('connection', async (socket) => {
      
      let token: string = socket.handshake.query.token.toString();

      if (token) {
        const secret = process.env.JWT_SECRET
        await this.jwtService.verifyAsync(token, { secret });
        const decoded = this.jwtService.decode(token);
        token = decoded['sub'];
        console.log('Client connected:', token);
        this.clients[socket.id] = { socket, token };
      } else {
        socket.emit('error', {
          status: 'error',
          message: 'No token provided',
          timestamp: new Date().toISOString(),
        });
        socket.disconnect();
      }

      socket.on('disconnect', () => {
        delete this.clients[socket.id];
      });
    });
  }

  private emitError(user_id: string, message: string) {
    const client = Object.values(this.clients).find(
      (client) => client.token === user_id
    );

    if (client) {
      client.socket.emit('notification', {
        status: 'error',
        message,
        timestamp: new Date().toISOString(),
      });
    }
  }
}
