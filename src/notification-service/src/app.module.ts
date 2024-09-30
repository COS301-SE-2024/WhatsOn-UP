import { Module } from '@nestjs/common';
import { NotificationModule } from './notification/notification.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [NotificationModule, AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
