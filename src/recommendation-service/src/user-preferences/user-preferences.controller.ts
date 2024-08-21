import { Body, Controller, Param, Post, Headers, UnauthorizedException } from '@nestjs/common';
import { UserPreferencesService } from './user-preferences.service';
import { InitPreferencesDto } from './dto/init-preferences.dto';

@Controller('preferences')
export class UserPreferencesController {
  constructor(private readonly userPreferencesService: UserPreferencesService) {}

  @Post('init')
  async initPreferences(
    @Headers('authorization') token: string,
    @Body() preferences: { categoryId: string, preferenceValue: number }[]
  ) {
    if (!token) {
      throw new UnauthorizedException({
        status: 'error',
        message: 'No token provided',
        timestamp: new Date().toISOString(),
      });
    }
    console.log('Token:', token);
    
    const userId = token.split(' ')[1];
    return this.userPreferencesService.initPreferences(userId, preferences);
  }

}
