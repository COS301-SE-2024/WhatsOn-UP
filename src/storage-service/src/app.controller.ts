import { Controller, Post, UploadedFile, UseInterceptors, Req, UnauthorizedException, HttpException, HttpStatus, Query, UploadedFiles, Delete } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AppService } from './app.service';
import { Request } from 'express';

@Controller('media')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Post('update')
  @UseInterceptors(FileInterceptor('file'))
  async uploadFile(@UploadedFile() file: any, @Req() request: Request) {
    const token = request.headers.authorization?.split(' ')[1];

    if (!token) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Token not provided or invalid',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.UNAUTHORIZED,
      );
    }

    const result = await this.appService.uploadProfile(file, token);
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

    const result = await this.appService.uploadEventMedia(file, event_id);
    return {
      status: 'success',
      message: 'File uploaded',
      timestamp: new Date().toISOString(),
      data: result,
    }
  }

  @Delete('delete')
  async deleteFile(@Query('media_name') media_name: string, @Req() request: Request) {

    const result = await this.appService.deleteMedia(media_name);
    return {
      status: 'success',
      message: 'File deleted',
      timestamp: new Date().toISOString(),
    }
  }
}
