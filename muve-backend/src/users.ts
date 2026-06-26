import { Router } from "express";
import { Prisma } from "@prisma/client";

import { sendError, logError } from "./api_response";
import { getUserIdFromRequest } from "./auth_user";
import { prisma } from "./prisma";
import { toAuthenticatedUser } from "./user_presenter";

const router = Router();

function cleanText(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}

function normalizeStringList(value: unknown) {
  if (!Array.isArray(value)) return undefined;
  return value.map((item) => cleanText(item)).filter(Boolean);
}

function normalizeSocialLinks(value: unknown) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return undefined;
  }

  const links = Object.entries(value as Record<string, unknown>).reduce(
    (acc, [key, link]) => {
      const cleanKey = key.trim();
      const cleanLink = cleanText(link);
      if (cleanKey && cleanLink) {
        acc[cleanKey] = cleanLink;
      }
      return acc;
    },
    {} as Record<string, string>
  );

  return links as Prisma.InputJsonValue;
}

router.patch("/me", async (req, res) => {
  try {
    const userId = getUserIdFromRequest(req);
    if (!userId) {
      return sendError(res, 401, "Usuário autenticado não informado");
    }

    const user = await prisma.usuario.findUnique({ where: { id: userId } });
    if (!user) {
      return sendError(res, 401, "Usuário autenticado não encontrado");
    }

    const data: Prisma.UsuarioUpdateInput = {};
    const body = req.body ?? {};

    if ("nome" in body) {
      const nome = cleanText(body.nome);
      if (!nome) return sendError(res, 400, "Nome não pode ficar vazio");
      data.nome = nome;
    }

    if ("bio" in body) data.bio = cleanText(body.bio) || null;
    if ("cidade" in body) data.cidade = cleanText(body.cidade) || null;
    if ("telefone" in body) data.telefone = cleanText(body.telefone) || null;

    if ("estado" in body) {
      const estado = cleanText(body.estado).toUpperCase();
      if (estado && !/^[A-Z]{2}$/.test(estado)) {
        return sendError(res, 400, "UF deve conter exatamente 2 letras");
      }
      data.estado = estado || null;
    }

    if ("faixaCache" in body) {
      data.faixaCache = cleanText(body.faixaCache) || null;
    }

    if ("generos" in body) {
      data.generos = normalizeStringList(body.generos) ?? [];
    }

    if ("redesSociais" in body) {
      data.redesSociais = normalizeSocialLinks(body.redesSociais) ?? {};
    }

    if ("disponivelContratacao" in body) {
      data.disponivelContratacao = Boolean(body.disponivelContratacao);
    }

    const updated = await prisma.usuario.update({
      where: { id: user.id },
      data,
    });

    return res.json({
      success: true,
      user: toAuthenticatedUser(updated),
    });
  } catch (error) {
    logError("users.updateMe", error);
    return sendError(res, 500, "Erro ao atualizar perfil");
  }
});

export default router;
