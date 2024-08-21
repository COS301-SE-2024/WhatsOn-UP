import { Body, Controller, Param, Post, Headers, UnauthorizedException } from '@nestjs/common';
import { UserPreferencesService } from './user-preferences.service';
import { InitPreferencesDto } from './dto/init-preferences.dto';
import { GetUserId } from '../get-user-id.decorator';

@Controller('preferences')
export class UserPreferencesController {
  constructor(private readonly userPreferencesService: UserPreferencesService) {}

  @Post('init')
  async initPreferences(
    @GetUserId() userId: string,
    @Body() preferences: { categoryId: string, preferenceValue: number }[]
  ) {
    if (!userId) {
      throw new UnauthorizedException({
        status: 'error',
        message: 'No (or invalid) token provided',
        timestamp: new Date().toISOString(),
      });
    }
    console.log('Token: ', userId);
    
    return this.userPreferencesService.initPreferences(userId, preferences);
  }

}
