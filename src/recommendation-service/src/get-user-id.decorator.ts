import { createParamDecorator, ExecutionContext } from '@nestjs/common';

//Extracts user id from request
export const GetUserId = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const token = request.headers['authorization'];
    if (token) {
      const parts = token.split(' ');
      if (parts.length === 2) {
        return parts[1]; // Assumes Bearer token format
      }
    }
    return null;
  },
);
