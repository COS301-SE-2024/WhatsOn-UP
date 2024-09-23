import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';

@Module({
    imports: [
        JwtModule.register({
            global: true,
            secret: process.env.JWT_SECRET,
        }),
    ],
    controllers: [],
    providers: [],
})
export class AuthModule {}