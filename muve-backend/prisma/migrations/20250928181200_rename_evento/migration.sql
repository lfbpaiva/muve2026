/*
  Warnings:

  - You are about to drop the `Evento` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "public"."Evento";

-- CreateTable
CREATE TABLE "public"."evento" (
    "id" SERIAL NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT,
    "local" TEXT NOT NULL,
    "data" TEXT,
    "hora" TEXT NOT NULL,
    "categoria" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "evento_pkey" PRIMARY KEY ("id")
);
