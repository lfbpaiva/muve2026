-- CreateEnum
CREATE TYPE "public"."TipoConta" AS ENUM ('ARTISTA', 'CONTRATANTE');

-- AlterTable
ALTER TABLE "public"."usuarios" ADD COLUMN     "tipoConta" "public"."TipoConta" NOT NULL DEFAULT 'ARTISTA';
