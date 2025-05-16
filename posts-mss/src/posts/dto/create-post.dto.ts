import { IsNotEmpty, IsString, IsInt } from 'class-validator';

export class CreatePostDto {
  @IsNotEmpty()
  @IsString()
  content: string;
}