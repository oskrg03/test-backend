import { Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Headers } from '@nestjs/common';
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  login(
    @Headers('email') email: string,
    @Headers('password') password: string,
  ) {
    return this.authService.login({ email, password });
  }
}
