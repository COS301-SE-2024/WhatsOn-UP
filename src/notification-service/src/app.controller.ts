import { Controller, Get, Headers } from '@nestjs/common';
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
}
