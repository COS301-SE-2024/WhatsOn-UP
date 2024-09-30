import { Body, Controller, Get, Param, Post, Res } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('reset-password')
  resetPasswordPage(): string {

    const htmlContent = this.appService.resetPasswordPage();
    return htmlContent;
  }

  @Post('reset-password')
  async resetPassword(
    @Body('email') email: string,
    @Body('password') password: string,
    @Body('recovery_token') recovery_token: string
  ) {
    return this.appService.resetPassword(email, password, recovery_token);
  }
}
