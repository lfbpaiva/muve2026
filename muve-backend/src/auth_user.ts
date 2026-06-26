import { Request } from "express";
import { PrismaClient, TipoConta, Usuario } from "@prisma/client";
import { userHasRole } from "./user_presenter";

type AuthError = {
  status: number;
  message: string;
};

export function getUserIdFromRequest(req: Request): string | undefined {
  const headerUserId = req.header("x-user-id");
  const body = req.body as Record<string, unknown> | undefined;
  const bodyUserId = body?.userId;
  const bodyArtistId = body?.artistId;
  const queryUserId = req.query.userId;

  const value =
    headerUserId ||
    (typeof bodyUserId === "string" ? bodyUserId : undefined) ||
    (typeof bodyArtistId === "string" ? bodyArtistId : undefined) ||
    (typeof queryUserId === "string" ? queryUserId : undefined);

  const trimmed = value?.trim();
  return trimmed || undefined;
}

export async function requireArtist(
  req: Request,
  prisma: PrismaClient
): Promise<{ user: Usuario } | { error: AuthError }> {
  return requireRole(req, prisma, TipoConta.ARTISTA);
}

export async function requireContratante(
  req: Request,
  prisma: PrismaClient
): Promise<{ user: Usuario } | { error: AuthError }> {
  return requireRole(req, prisma, TipoConta.CONTRATANTE);
}

export async function requireRole(
  req: Request,
  prisma: PrismaClient,
  role: TipoConta
): Promise<{ user: Usuario } | { error: AuthError }> {
  const userId = getUserIdFromRequest(req);

  if (!userId) {
    return {
      error: {
        status: 401,
        message: "Usuário autenticado não informado",
      },
    };
  }

  const user = await prisma.usuario.findUnique({
    where: { id: userId },
  });

  if (!user) {
    return {
      error: {
        status: 401,
        message: "Usuário autenticado não encontrado",
      },
    };
  }

  if (!userHasRole(user, role)) {
    return {
      error: {
        status: 403,
        message:
          role === TipoConta.ARTISTA
            ? "Apenas artistas podem acessar este recurso"
            : "Apenas contratantes podem acessar este recurso",
      },
    };
  }

  return { user };
}
