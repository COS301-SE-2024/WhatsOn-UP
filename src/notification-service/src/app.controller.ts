import { Controller, Delete, Get, Headers, Param } from '@nestjs/common';
import { AppService } from './app.service';
import { UnauthorizedException } from '@nestjs/common';

@Controller('notifications')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('get_all')
  async getNotifications(@Headers('authorization') token: string): Promise<any> {
    console.log('Token:', token);
    if (!token) {
      
      throw new UnauthorizedException({
        status: 'error',
        message: 'No token provided',
        timestamp: new Date().toISOString(),
      });
    }
    const userId = token.split(' ')[1];
    return await this.appService.getNotifications(userId);
  }

  @Delete('delete_all')
  async deleteNotifications(@Headers('authorization') token: string): Promise<any> {
    console.log('Token:', token);
    if (!token) {
      throw new UnauthorizedException({
        status: 'error',
        message: 'No token provided',
        timestamp: new Date().toISOString(),
      });
    }

    const parts = token.split(' ');
    if (parts.length !== 2 || parts[0] !== 'Bearer') {
      throw new UnauthorizedException({
        status: 'error',
        message: 'Invalid token format',
        timestamp: new Date().toISOString(),
      });
    }

    const userId = parts[1];
    return await this.appService.deleteNotifications(userId);
  }

  @Delete('delete/:notification_id')
  async deleteNotification(
    @Headers('authorization') token: string,
    @Param('notification_id') notification_id: string
  ): Promise<any> {
    console.log('Token:', token);
    if (!token) {
      throw new UnauthorizedException({
        status: 'error',
        message: 'No token provided',
        timestamp: new Date().toISOString(),
      });
    }

    // Token should be in the format 'Bearer <token>'
    const parts = token.split(' ');
    if (parts.length !== 2 || parts[0] !== 'Bearer') {
      throw new UnauthorizedException({
        status: 'error',
        message: 'Invalid token format',
        timestamp: new Date().toISOString(),
      });
    }

    const userId = parts[1];
    return await this.appService.deleteNotification(userId, notification_id);
  }

}
