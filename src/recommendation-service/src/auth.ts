import { createParamDecorator, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';

// Extracts JWT token from request
export const GetAccessToken = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const authorizationHeader = request.headers['authorization'];
    
    if (authorizationHeader) {
      const parts = authorizationHeader.split(' ');
      if (parts.length === 2 && parts[0] === 'Bearer') {
        return parts[1]; // Return the JWT token
      }
    }

    throw new UnauthorizedException({
      status: 'error',
      message: 'No (or invalid) token provided',
      timestamp: new Date().toISOString(),
    });
  },
);

export function extractUserIdFromToken(token: string): string {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET) as any; 

    if (decoded && decoded.sub) {
      return decoded.sub;
    }

    throw new UnauthorizedException({
      status: 'error',
      message: 'User ID (sub) not found in token',
      timestamp: new Date().toISOString(),
    });

  } catch (err) {
    throw new UnauthorizedException({
      status: 'error',
      message: 'Invalid token',
      timestamp: new Date().toISOString(),
    });
  }
}
