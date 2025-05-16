/* eslint-disable @typescript-eslint/no-misused-promises */
import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleDestroy {
  constructor() {
    super();
    process.on('beforeExit', async () => {
      await this.$disconnect();
    });
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
