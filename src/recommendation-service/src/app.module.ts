import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PreferencesModule } from './preferences/preferences.module';

@Module({
  imports: [PreferencesModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
