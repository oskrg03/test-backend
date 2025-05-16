import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findByUseId(id: string) {
    const profile = await this.prisma.user.findUnique({
      where: { id: Number(id) },
      select: {
        id: true,
        email: true,
        profile: {
          select: {
            name: true,
            avatar: true,
          },
        },
      },
    });
    if (!profile) throw new NotFoundException('Usuario no encontrado');
    return profile;
  }
}
