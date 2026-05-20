// src/events_contratante.ts
import { Router } from "express";
import { PrismaClient } from "@prisma/client";

const router = Router();
const prisma = new PrismaClient();

// GET – listar eventos
router.get("/", async (_req, res) => {
  try {
    const eventos = await prisma.evento.findMany({
      orderBy: { id: "desc" },
    });
    res.json(eventos);
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao listar eventos" });
  }
});

// POST – criar evento
router.post("/", async (req, res) => {
  try {
    const { titulo, descricao, local, data, hora, categoria } = req.body ?? {};

    // obrigatórios
    if (!titulo || !hora || !local || !data) {
      return res.status(400).json({
        success: false,
        message: "Título, Data, Hora e Local são obrigatórios",
      });
    }

    const dataStr = String(data).trim();
    const horaStr = String(hora).trim();

    const errors: string[] = [];

    // Validação da data: DD/MM/AAAA e não pode ser passada
    const dataRegex = /^\d{2}\/\d{2}\/\d{4}$/;
    if (!dataRegex.test(dataStr)) {
      errors.push("Data deve estar no formato DD/MM/AAAA");
    } else {
      const [diaStr, mesStr, anoStr] = dataStr.split("/");
      const dia = Number(diaStr);
      const mes = Number(mesStr);
      const ano = Number(anoStr);

      const jsDate = new Date(ano, mes - 1, dia);

      if (
        jsDate.getFullYear() !== ano ||
        jsDate.getMonth() !== mes - 1 ||
        jsDate.getDate() !== dia
      ) {
        errors.push("Data inválida");
      } else {
        const hoje = new Date();
        hoje.setHours(0, 0, 0, 0);
        jsDate.setHours(0, 0, 0, 0);
        if (jsDate < hoje) {
          errors.push("Data do evento não pode ser no passado");
        }
      }
    }

    // Validação da hora: HH:MM no formato 24h
    const horaRegex = /^\d{2}:\d{2}$/;
    if (!horaRegex.test(horaStr)) {
      errors.push("Hora deve estar no formato HH:MM (24h)");
    } else {
      const [hStr, mStr] = horaStr.split(":");
      const h = Number(hStr);
      const m = Number(mStr);
      if (
        Number.isNaN(h) ||
        Number.isNaN(m) ||
        h < 0 ||
        h > 23 ||
        m < 0 ||
        m > 59
      ) {
        errors.push("Hora inválida");
      }
    }

    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: errors.join(" | "),
      });
    }

    const evento = await prisma.evento.create({
      data: {
        titulo,
        descricao,
        local,
        data: dataStr, // continua String no banco, mas agora validada
        hora: horaStr,
        categoria,
      },
    });

    res.status(201).json(evento);
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao criar evento" });
  }
});

// DELETE – excluir evento
router.delete("/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    await prisma.evento.delete({ where: { id } });
    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res
      .status(500)
      .json({ success: false, message: "Erro ao excluir evento" });
  }
});

export default router;
