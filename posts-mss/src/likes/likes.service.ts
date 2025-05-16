/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LikesService {
  constructor(private readonly prisma: PrismaService) {}

  async likePost(postId: number, userId: number) {
    try {
      return await this.prisma.like.create({
        data: {
          postId,
          userId,
        },
      });
    } catch (error) {
        console.log(error);
        
      if (error.code === 'P2002') {
        throw new ConflictException('Ya diste like a este post');
      }
      throw error;
    }
  }
}
