-- CreateEnum
CREATE TYPE "public"."ApplicationStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELED');

-- AlterTable
ALTER TABLE "public"."evento"
ADD COLUMN "cidade" TEXT,
ADD COLUMN "estado" TEXT,
ADD COLUMN "cacheEstimado" TEXT,
ADD COLUMN "contratando" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN "contratanteId" TEXT,
ADD COLUMN "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- CreateTable
CREATE TABLE "public"."event_applications" (
    "id" TEXT NOT NULL,
    "artistId" TEXT NOT NULL,
    "eventId" INTEGER NOT NULL,
    "status" "public"."ApplicationStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "event_applications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "event_applications_artistId_eventId_key" ON "public"."event_applications"("artistId", "eventId");

-- CreateIndex
CREATE INDEX "event_applications_artistId_idx" ON "public"."event_applications"("artistId");

-- CreateIndex
CREATE INDEX "event_applications_eventId_idx" ON "public"."event_applications"("eventId");

-- AddForeignKey
ALTER TABLE "public"."evento" ADD CONSTRAINT "evento_contratanteId_fkey" FOREIGN KEY ("contratanteId") REFERENCES "public"."usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."event_applications" ADD CONSTRAINT "event_applications_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "public"."usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."event_applications" ADD CONSTRAINT "event_applications_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "public"."evento"("id") ON DELETE CASCADE ON UPDATE CASCADE;
