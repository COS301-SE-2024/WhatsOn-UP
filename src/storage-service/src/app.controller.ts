import { Controller, Post, UploadedFile, UseInterceptors, Req, UnauthorizedException, HttpException, HttpStatus, Query, UploadedFiles, Delete, UseGuards } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AppService } from './app.service';
import { Request } from 'express';
import { JwtGuard } from './auth/jwt.guard';

@Controller('media')
@UseGuards(JwtGuard)
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Post('update')
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(@UploadedFile() file: any, @Req() request: Request) {

    const result = await this.appService.uploadProfile(file, request['user_id']);
    return {
      status: 'success',
      message: 'File uploaded',
      timestamp: new Date().toISOString(),
      data: result,
    }
  }

  @Post('upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadEventMedia(
    @UploadedFile() file:  any,
    @Query('event_id') event_id: string,
    @Req() request: Request
  ) {

    if (!event_id) {
      throw new HttpException(
        {
          status: 'error',
          message: 'event_id not provided or invalid',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.UNAUTHORIZED,
      );
    }

    const user_id = request['user_id'];

    const result = await this.appService.uploadEventMedia(file, event_id, user_id);
    return {
      status: 'success',
      message: 'File uploaded',
      timestamp: new Date().toISOString(),
      data: result,
    }
  }

  @Post('proof')
  @UseInterceptors(FileInterceptor('file'))
  async uploadProof(
    @UploadedFile() file:  any,
    @Query('application_id') application_id: string,
    @Req() request: Request
  ) {

    if (!application_id) {
      throw new HttpException(
        {
          status: 'error',
          message: 'application_id not provided or invalid',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.UNAUTHORIZED,
      );
    }

    const result = await this.appService.uploadProof(file, application_id, request['user_id']);
    return {
      status: 'success',
      message: 'File uploaded',
      timestamp: new Date().toISOString(),
      data: result,
    }
  }

  @Delete('delete')
  async deleteFile(@Query('media_name') media_name: string, @Req() request: Request) {

    const result = await this.appService.deleteMedia(media_name, request['user_id']);
    return {
      status: 'success',
      message: 'File deleted',
      timestamp: new Date().toISOString(),
    }
  }
}
