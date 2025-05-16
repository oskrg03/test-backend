import { Controller, Post, Param, UseGuards, Req } from '@nestjs/common';
import { LikesService } from './likes.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/posts/jwt-auth.guard';

@ApiTags('likes')
@ApiBearerAuth()
@Controller('posts/:id/like')
@UseGuards(JwtAuthGuard)
export class LikesController {
  constructor(private readonly likesService: LikesService) {}

  @Post()
  likePost(@Param('id') postId: string, @Req() req: any) {
    return this.likesService.likePost(Number(postId), req.user.userId);
  }
}
