import { Injectable, CanActivate, ExecutionContext, HttpException, HttpStatus } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class JwtGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}
  async canActivate(
    context: ExecutionContext,
  ): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = request.headers.authorization?.split(' ')[1];

    if (!token) {
      throw new HttpException(
        {
          status: 'error',
          message: 'JWT Token not provided',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.UNAUTHORIZED,
      );
    }

    try {
      const secret = process.env.JWT_SECRET
      await this.jwtService.verifyAsync(token, { secret });
      const decoded = this.jwtService.decode(token);
      request['user_id'] = decoded['sub'];
      return true;
    } catch (error) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Invalid or expired JWT Token',
          timestamp: new Date().toISOString(),
        },
        HttpStatus.UNAUTHORIZED,
      );
    }
  }
}
