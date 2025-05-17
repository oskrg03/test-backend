/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LikesService {
  constructor(private readonly prisma: PrismaService) { }

  async likePost(postId: number, userId: number) {
    try {
      const existingLike = await this.prisma.like.findUnique({
        where: {
          postId_userId: {
            postId,
            userId,
          },
        },
      });

      if (existingLike) {
        // Si ya existe el like, lo elimina (toggle off)
        await this.prisma.like.delete({
          where: {
            postId_userId: {
              postId,
              userId,
            },
          },
        });
        return true;
      } else {
        // Si no existe, lo crea (toggle on)
        await this.prisma.like.create({
          data: {
            postId,
            userId,
          },
        });
        return true;
      }
    } catch (error) {
      console.log(error);
      throw error;
    }
  }
}
