-- CreateEnum
CREATE TYPE "public"."TipoPessoa" AS ENUM ('PF', 'PJ');

-- CreateTable
CREATE TABLE "public"."usuario" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "telefone" TEXT,
    "tipoPessoa" "public"."TipoPessoa" NOT NULL DEFAULT 'PF',
    "cpf" TEXT,
    "cnpj" TEXT,
    "razaoSocial" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "usuario_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuario_email_key" ON "public"."usuario"("email");

-- CreateIndex
CREATE UNIQUE INDEX "usuario_cpf_key" ON "public"."usuario"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "usuario_cnpj_key" ON "public"."usuario"("cnpj");
