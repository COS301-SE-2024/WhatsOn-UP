import { Controller, Delete, Get, Headers, Param, UseGuards, Req, Post} from '@nestjs/common';
import { AppService } from './app.service';
import { JwtGuard } from './auth/jwt.guard';

@Controller('notifications')
@UseGuards(JwtGuard)
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('get_all')
  async getNotifications(@Headers('authorization') token: string, @Req() request: Request): Promise<any> {
    return await this.appService.getNotifications(request['user_id']);
  }

  @Delete('delete_all')
  async deleteNotifications(@Headers('authorization') token: string, @Req() request: Request): Promise<any> {
    return await this.appService.deleteNotifications(request['user_id']);
  }

  @Delete('delete/:notification_id')
  async deleteNotification(
    @Headers('authorization') token: string,
    @Param('notification_id') notification_id: string,
    @Req() request: Request
  ): Promise<any> {
    return await this.appService.deleteNotification(request['user_id'], notification_id);
  }

  @Post('mark_read/:notification_id')
  async markNotificationRead(
    @Headers('authorization') token: string,
    @Param('notification_id') notification_id: string,
    @Req() request: Request
  ): Promise<any> {
    return await this.appService.markNotificationRead(request['user_id'], notification_id);
  }

}
