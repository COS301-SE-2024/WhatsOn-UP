import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as dotenv from 'dotenv';
import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';

async function bootstrap() {
  dotenv.config();
  const app = await NestFactory.create(AppModule);

  const corsOptions: CorsOptions = {
    origin: 'https://frontend-1035006743185.us-central1.run.app', // Allowed origin url(s)
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],         // Allowed methods
  };

  app.enableCors(corsOptions);
  await app.listen(8081);
}
bootstrap();
