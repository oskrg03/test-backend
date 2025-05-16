import { Injectable } from '@nestjs/common';
import { CreatePostDto } from './dto/create-post.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) { }

  create(userId: number, dto: CreatePostDto) {
    return this.prisma.post.create({
      data: {
        content: dto.content,
        userId,
      },
    });
  }

  async findAllExceptUser(userId: number) {
    return this.prisma.post.findMany({
      where: {
        userId: {
          not: userId,
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
      include: {
        likes: true, // incluir los likes asociados al post
      }
    });
  }

}
