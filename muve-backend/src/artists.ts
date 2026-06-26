import { Router } from "express";
import { TipoConta } from "@prisma/client";

import { sendError, logError } from "./api_response";
import { requireArtist } from "./auth_user";
import { prisma } from "./prisma";
import { toPublicArtist } from "./user_presenter";

const router = Router();

function queryText(value: unknown) {
  return typeof value === "string" ? value.trim().toLowerCase() : "";
}

router.get("/", async (req, res) => {
  try {
    const query = queryText(req.query.query);
    const genero = queryText(req.query.genero);
    const cidade = queryText(req.query.cidade);
    const disponivelApenas = req.query.disponivelApenas === "true";

    const artists = await prisma.usuario.findMany({
      where: {
        OR: [
          { tipoConta: TipoConta.ARTISTA },
          { papeis: { has: TipoConta.ARTISTA } },
        ],
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    const filtered = artists.filter((artist) => {
      if (query) {
        const searchable = [
          artist.nome,
          artist.bio,
          artist.cidade,
          artist.estado,
          ...artist.generos,
        ]
          .filter(Boolean)
          .join(" ")
          .toLowerCase();
        if (!searchable.includes(query)) return false;
      }

      if (cidade) {
        const artistCidade = artist.cidade?.toLowerCase() ?? "";
        if (!artistCidade.includes(cidade)) return false;
      }

      if (genero) {
        const hasGenre = artist.generos.some(
          (artistGenero) => artistGenero.toLowerCase() === genero
        );
        if (!hasGenre) return false;
      }

      if (disponivelApenas && !artist.disponivelContratacao) {
        return false;
      }

      return true;
    });

    return res.json(filtered.map(toPublicArtist));
  } catch (error) {
    logError("artists.list", error);
    return sendError(res, 500, "Erro ao listar artistas");
  }
});

router.get("/me/applications", async (req, res) => {
  try {
    const auth = await requireArtist(req, prisma);
    if ("error" in auth) {
      return sendError(res, auth.error.status, auth.error.message);
    }

    const applications = await prisma.eventApplication.findMany({
      where: {
        artistId: auth.user.id,
      },
      orderBy: {
        createdAt: "desc",
      },
      include: {
        event: true,
      },
    });

    return res.json(applications);
  } catch (error) {
    logError("artists.applications", error);
    return sendError(res, 500, "Erro ao listar inscrições do artista");
  }
});

export default router;
