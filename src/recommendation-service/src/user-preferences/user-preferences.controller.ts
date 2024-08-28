import { Body, Controller, Param, Post, Headers, UnauthorizedException, Put } from '@nestjs/common';
import { UserPreferencesService } from './user-preferences.service';
import { InitPreferencesDto } from './dto/init-preferences.dto';
import { GetUserId } from '../get-user-id.decorator';

@Controller('preferences')
export class UserPreferencesController {
  constructor(private readonly userPreferencesService: UserPreferencesService) {}

  @Post('init')
  async initPreferences(
    @GetUserId() userId: string,
    @Body() initPreferencesDto: InitPreferencesDto
  ) {
    console.log('Token: ', userId);
    return this.userPreferencesService.initPreferences(userId, initPreferencesDto);
  }

  @Put('update')
  async updatePreferences(
    @GetUserId() userId: string
  ){
    console.log('Token: ', userId);
    return this.userPreferencesService.updatePreferences(userId)
  }

}
