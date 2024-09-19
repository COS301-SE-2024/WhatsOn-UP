import { Body, Controller, Param, Post, Headers, UnauthorizedException, Put, Get } from '@nestjs/common';
import { UserPreferencesService } from './user-preferences.service';
import { InitPreferencesDto } from './dto/init-preferences.dto';
import { extractUserIdFromToken, GetAccessToken } from '../auth';

@Controller('preferences')
export class UserPreferencesController {
  constructor(private readonly userPreferencesService: UserPreferencesService) {}

  @Post('init')
  async initPreferences(
    @GetAccessToken() accessToken: string,
    @Body() initPreferencesDto: InitPreferencesDto
  ) {
    const userId = extractUserIdFromToken(accessToken);
    return this.userPreferencesService.initPreferences(userId, initPreferencesDto);
  }

}
