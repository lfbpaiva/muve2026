import { Router } from "express";
import { TipoConta } from "@prisma/client";

import { sendError, logError } from "./api_response";
import {
  getUserIdFromRequest,
  requireArtist,
  requireContratante,
} from "./auth_user";
import { prisma } from "./prisma";
import { userHasRole } from "./user_presenter";

const router = Router();

const eventInclude = {
  contratante: {
    select: {
      id: true,
      nome: true,
    },
  },
};

function cleanText(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}

function parseEventId(value: unknown) {
  const id = Number(value);
  return Number.isInteger(id) && id > 0 ? id : null;
}

function validateEventDate(data: string, hora: string) {
  const errors: string[] = [];
  const dataRegex = /^\d{2}\/\d{2}\/\d{4}$/;

  if (!dataRegex.test(data)) {
    errors.push("Data deve estar no formato DD/MM/AAAA");
  } else {
    const [diaStr, mesStr, anoStr] = data.split("/");
    const dia = Number(diaStr);
    const mes = Number(mesStr);
    const ano = Number(anoStr);
    const eventDate = new Date(ano, mes - 1, dia);

    if (
      eventDate.getFullYear() !== ano ||
      eventDate.getMonth() !== mes - 1 ||
      eventDate.getDate() !== dia
    ) {
      errors.push("Data inválida");
    } else {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      eventDate.setHours(0, 0, 0, 0);
      if (eventDate < today) {
        errors.push("Data do evento não pode ser no passado");
      }
    }
  }

  const horaRegex = /^\d{2}:\d{2}$/;
  if (!horaRegex.test(hora)) {
    errors.push("Hora deve estar no formato HH:MM (24h)");
  } else {
    const [hStr, mStr] = hora.split(":");
    const hour = Number(hStr);
    const minute = Number(mStr);
    if (
      Number.isNaN(hour) ||
      Number.isNaN(minute) ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59
    ) {
      errors.push("Hora inválida");
    }
  }

  return errors;
}

router.get("/", async (_req, res) => {
  try {
    const eventos = await prisma.evento.findMany({
      orderBy: { id: "desc" },
      include: eventInclude,
    });
    return res.json(eventos);
  } catch (error) {
    logError("events.list", error);
    return sendError(res, 500, "Erro ao listar eventos");
  }
});

router.post("/", async (req, res) => {
  try {
    const auth = await requireContratante(req, prisma);
    if ("error" in auth) {
      return sendError(res, auth.error.status, auth.error.message);
    }

    const {
      titulo,
      descricao,
      local,
      cidade,
      estado,
      data,
      hora,
      categoria,
      cacheEstimado,
      contratando,
    } = req.body ?? {};

    const tituloValue = cleanText(titulo);
    const localValue = cleanText(local);
    const dataValue = cleanText(data);
    const horaValue = cleanText(hora);

    if (!tituloValue || !horaValue || !localValue || !dataValue) {
      return sendError(
        res,
        400,
        "Título, data, hora e local são obrigatórios"
      );
    }

    const errors = validateEventDate(dataValue, horaValue);
    if (errors.length > 0) {
      return sendError(res, 400, errors.join(" | "));
    }

    const contratandoValue =
      typeof contratando === "boolean"
        ? contratando
        : contratando === undefined
          ? true
          : String(contratando).toLowerCase() !== "false";

    const evento = await prisma.evento.create({
      data: {
        titulo: tituloValue,
        descricao: cleanText(descricao) || null,
        local: localValue,
        cidade: cleanText(cidade) || null,
        estado: cleanText(estado).toUpperCase() || null,
        data: dataValue,
        hora: horaValue,
        categoria: cleanText(categoria) || null,
        cacheEstimado: cleanText(cacheEstimado) || null,
        contratando: contratandoValue,
        contratanteId: auth.user.id,
      },
      include: eventInclude,
    });

    return res.status(201).json(evento);
  } catch (error) {
    logError("events.create", error);
    return sendError(res, 500, "Erro ao criar evento");
  }
});

router.post("/:eventId/applications", async (req, res) => {
  try {
    const eventId = parseEventId(req.params.eventId);
    if (!eventId) {
      return sendError(res, 400, "ID do evento inválido");
    }

    const auth = await requireArtist(req, prisma);
    if ("error" in auth) {
      return sendError(res, auth.error.status, auth.error.message);
    }

    const evento = await prisma.evento.findUnique({
      where: { id: eventId },
    });

    if (!evento) {
      return sendError(res, 404, "Evento não encontrado");
    }

    if (!evento.contratando) {
      return sendError(res, 409, "Evento não está recebendo candidaturas");
    }

    const existing = await prisma.eventApplication.findUnique({
      where: {
        artistId_eventId: {
          artistId: auth.user.id,
          eventId,
        },
      },
      include: {
        event: true,
      },
    });

    if (existing) {
      return res.status(409).json({
        success: false,
        message: "Você já se inscreveu nesse evento",
        application: existing,
      });
    }

    const application = await prisma.eventApplication.create({
      data: {
        artistId: auth.user.id,
        eventId,
      },
      include: {
        event: true,
      },
    });

    return res.status(201).json({
      success: true,
      application,
    });
  } catch (error: unknown) {
    logError("events.apply", error);

    if (String((error as { code?: string })?.code) === "P2002") {
      return sendError(res, 409, "Você já se inscreveu nesse evento");
    }

    return sendError(res, 500, "Erro ao criar inscrição no evento");
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const id = parseEventId(req.params.id);
    if (!id) {
      return sendError(res, 400, "ID do evento inválido");
    }

    const userId = getUserIdFromRequest(req);
    if (!userId) {
      return sendError(res, 401, "Usuário autenticado não informado");
    }

    const [user, evento] = await Promise.all([
      prisma.usuario.findUnique({ where: { id: userId } }),
      prisma.evento.findUnique({ where: { id } }),
    ]);

    if (!user) {
      return sendError(res, 401, "Usuário autenticado não encontrado");
    }

    if (!evento) {
      return sendError(res, 404, "Evento não encontrado");
    }

    const canDelete =
      evento.contratanteId === user.id || userHasRole(user, TipoConta.ADMIN);
    if (!canDelete) {
      return sendError(res, 403, "Você não pode excluir este evento");
    }

    await prisma.evento.delete({ where: { id } });
    return res.json({ success: true });
  } catch (error) {
    logError("events.delete", error);
    return sendError(res, 500, "Erro ao excluir evento");
  }
});

export default router;
