import { Module } from '@nestjs/common';
import { NotificationModule } from './notification/notification.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [NotificationModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
