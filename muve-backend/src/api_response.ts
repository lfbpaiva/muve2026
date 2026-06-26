import type { Response } from "express";

export function sendError(res: Response, status: number, message: string) {
  return res.status(status).json({
    success: false,
    message,
  });
}

export function logError(scope: string, error: unknown) {
  const details =
    error instanceof Error
      ? { name: error.name, message: error.message }
      : { message: String(error) };

  console.error(`[${scope}]`, details);
}
