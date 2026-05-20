// src/index.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";

import loginRouter from "./login";                  // ← novo nome
import eventsContratanteRouter from "./events_contratante";

dotenv.config();

const app = express();
const prisma = new PrismaClient();

app.use(cors({ origin: true, credentials: true }));
app.use(express.json());

// Healthcheck
app.get("/health", async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ ok: true });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

// Monta os routers
app.use("/auth", loginRouter);            // /auth/register e /auth/login
app.use("/eventos", eventsContratanteRouter); // /eventos GET/POST/DELETE

// Porta e host
const PORT = Number(process.env.PORT || 3000);
app.listen(PORT, "0.0.0.0", () => {
  console.log(`API rodando em http://192.168.1.2:${PORT}`);
});
