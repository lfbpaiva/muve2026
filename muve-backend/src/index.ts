import express from "express";
import cors from "cors";
import type { CorsOptions } from "cors";
import dotenv from "dotenv";

import loginRouter from "./login";
import eventsContratanteRouter from "./events_contratante";
import artistsRouter from "./artists";
import usersRouter from "./users";
import { prisma } from "./prisma";

dotenv.config();

export const app = express();

const localDevOriginPattern =
  /^https?:\/\/(localhost|127\.0\.0\.1|\[::1\])(:\d+)?$/;
const configuredOrigins = (process.env.CORS_ORIGIN ?? "")
  .split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

const corsOptions: CorsOptions = {
  credentials: true,
  origin(origin, callback) {
    if (
      !origin ||
      localDevOriginPattern.test(origin) ||
      configuredOrigins.includes(origin)
    ) {
      callback(null, true);
      return;
    }

    callback(new Error(`Origem não permitida pelo CORS: ${origin}`));
  },
};

app.use(cors(corsOptions));
app.use(express.json());

app.get("/", (_req, res) => {
  res.json({ status: "ok", service: "muve-backend" });
});

app.get("/health", async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ ok: true });
  } catch (_error) {
    res.status(500).json({
      ok: false,
      message: "Banco de dados indisponível",
    });
  }
});

app.use("/auth", loginRouter);
app.use("/eventos", eventsContratanteRouter);
app.use("/events", eventsContratanteRouter);
app.use("/artists", artistsRouter);
app.use("/users", usersRouter);

export function startServer(port = Number(process.env.PORT || 3000)) {
  return app.listen(port, "0.0.0.0", () => {
    console.info(`API rodando em http://localhost:${port}`);
    console.info(`Escutando conexões externas em 0.0.0.0:${port}`);
  });
}

if (require.main === module) {
  startServer();
}
