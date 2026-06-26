ALTER TABLE "public"."usuarios"
ADD COLUMN "fotoPerfil" TEXT,
ADD COLUMN "bio" TEXT,
ADD COLUMN "cidade" TEXT,
ADD COLUMN "estado" TEXT,
ADD COLUMN "generos" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
ADD COLUMN "redesSociais" JSONB,
ADD COLUMN "faixaCache" TEXT,
ADD COLUMN "disponivelContratacao" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN "perfilPago" BOOLEAN NOT NULL DEFAULT false;
