ALTER TABLE "usuarios" ADD COLUMN "papeis" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];

UPDATE "usuarios"
SET "papeis" = ARRAY["tipoConta"::TEXT]
WHERE array_length("papeis", 1) IS NULL;
