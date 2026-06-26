import { Router, Request, Response } from "express";
import { Prisma, TipoConta, TipoPessoa } from "@prisma/client";
import bcrypt from "bcryptjs";

import { sendError, logError } from "./api_response";
import { prisma } from "./prisma";
import { normalizeRoles, toAuthenticatedUser } from "./user_presenter";

const router = Router();

const registerRoles: TipoConta[] = [TipoConta.ARTISTA, TipoConta.CONTRATANTE];

function cleanText(value: unknown) {
  return typeof value === "string" ? value.trim() : "";
}

function cleanDocument(value: unknown) {
  const digits = cleanText(value).replace(/\D/g, "");
  return digits || null;
}

function isValidEmail(email: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function normalizeRegisterRoles(rawRoles: unknown, rawRole: unknown) {
  const fromArray = normalizeRoles(rawRoles).filter((role) =>
    registerRoles.includes(role)
  );

  if (fromArray.length > 0) {
    return fromArray;
  }

  const fallback = cleanText(rawRole).toUpperCase();
  return registerRoles.includes(fallback as TipoConta)
    ? [fallback as TipoConta]
    : [];
}

function primaryRoleFor(roles: TipoConta[]) {
  return roles.includes(TipoConta.CONTRATANTE) &&
    !roles.includes(TipoConta.ARTISTA)
    ? TipoConta.CONTRATANTE
    : TipoConta.ARTISTA;
}

function personTypeFor(rawTipoPessoa: unknown, roles: TipoConta[]) {
  const value = cleanText(rawTipoPessoa).toUpperCase();
  if (value === TipoPessoa.PF || value === TipoPessoa.PJ) {
    return value as TipoPessoa;
  }

  return roles.includes(TipoConta.CONTRATANTE) &&
    !roles.includes(TipoConta.ARTISTA)
    ? TipoPessoa.PJ
    : TipoPessoa.PF;
}

function normalizeSocialLinks(value: unknown) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return null;
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

  return Object.keys(links).length > 0
    ? (links as Prisma.InputJsonValue)
    : null;
}

router.post("/register", async (req: Request, res: Response) => {
  try {
    const {
      nome,
      email,
      senha,
      telefone,
      fotoPerfil,
      bio,
      cidade,
      estado,
      generos,
      redesSociais,
      faixaCache,
      disponivelContratacao,
      tipoPessoa,
      cpf,
      cnpj,
      razaoSocial,
      tipoConta,
      papeis,
    } = req.body ?? {};

    const nomeValue = cleanText(nome);
    const emailValue = cleanText(email).toLowerCase();
    const senhaValue = cleanText(senha);
    const cidadeValue = cleanText(cidade);
    const estadoValue = cleanText(estado).toUpperCase();
    const roles = normalizeRegisterRoles(papeis, tipoConta);
    const cpfValue = cleanDocument(cpf);
    const cnpjValue = cleanDocument(cnpj);

    if (!nomeValue || !emailValue || !senhaValue) {
      return sendError(res, 400, "Nome, e-mail e senha são obrigatórios");
    }

    if (!isValidEmail(emailValue)) {
      return sendError(res, 400, "Informe um e-mail válido");
    }

    if (senhaValue.length < 6) {
      return sendError(res, 400, "A senha deve ter pelo menos 6 caracteres");
    }

    if (roles.length === 0) {
      return sendError(
        res,
        400,
        "Selecione pelo menos um papel: ARTISTA ou CONTRATANTE"
      );
    }

    if (roles.includes(TipoConta.ARTISTA) && cpfValue?.length !== 11) {
      return sendError(res, 400, "CPF válido é obrigatório para artistas");
    }

    if (roles.includes(TipoConta.CONTRATANTE) && cnpjValue?.length !== 14) {
      return sendError(
        res,
        400,
        "CNPJ válido é obrigatório para contratantes"
      );
    }

    if (estadoValue && !/^[A-Z]{2}$/.test(estadoValue)) {
      return sendError(res, 400, "UF deve conter exatamente 2 letras");
    }

    const existing = await prisma.usuario.findUnique({
      where: { email: emailValue },
    });

    if (existing) {
      return sendError(res, 409, "E-mail já cadastrado");
    }

    const generosList = Array.isArray(generos)
      ? generos.map((genero) => cleanText(genero)).filter(Boolean)
      : [];

    const hash = await bcrypt.hash(senhaValue, 10);
    const primaryRole = primaryRoleFor(roles);
    const tipoPessoaEnum = personTypeFor(tipoPessoa, roles);
    const razaoSocialValue = cleanText(razaoSocial) || nomeValue;
    const socialLinks = normalizeSocialLinks(redesSociais);

    const user = await prisma.usuario.create({
      data: {
        nome: nomeValue,
        email: emailValue,
        senha: hash,
        telefone: cleanText(telefone) || null,
        fotoPerfil: cleanText(fotoPerfil) || null,
        bio: cleanText(bio) || null,
        cidade: cidadeValue || null,
        estado: estadoValue || null,
        papeis: roles,
        generos: generosList,
        ...(socialLinks ? { redesSociais: socialLinks } : {}),
        faixaCache: cleanText(faixaCache) || null,
        disponivelContratacao: Boolean(disponivelContratacao),
        tipoPessoa: tipoPessoaEnum,
        tipoConta: primaryRole,
        cpf: cpfValue,
        cnpj: cnpjValue,
        razaoSocial: cnpjValue ? razaoSocialValue : null,
      },
    });

    return res.status(201).json({
      success: true,
      user: toAuthenticatedUser(user),
    });
  } catch (error: unknown) {
    logError("auth.register", error);

    if (String((error as { code?: string })?.code) === "P2002") {
      return sendError(res, 409, "E-mail, CPF ou CNPJ já cadastrado");
    }

    return sendError(res, 500, "Erro interno ao criar conta");
  }
});

router.post("/login", async (req: Request, res: Response) => {
  try {
    const email = cleanText(req.body?.email).toLowerCase();
    const senha = cleanText(req.body?.senha);

    if (!email || !senha) {
      return sendError(res, 400, "E-mail e senha são obrigatórios");
    }

    const user = await prisma.usuario.findUnique({
      where: { email },
    });

    if (!user) {
      return sendError(res, 401, "Credenciais inválidas");
    }

    const ok = await bcrypt.compare(senha, user.senha);
    if (!ok) {
      return sendError(res, 401, "Credenciais inválidas");
    }

    return res.json({
      success: true,
      user: toAuthenticatedUser(user),
    });
  } catch (error) {
    logError("auth.login", error);
    return sendError(res, 500, "Erro interno ao realizar login");
  }
});

router.get("/usuarios", async (req: Request, res: Response) => {
  try {
    const tipoConta = cleanText(req.query.tipoConta).toUpperCase();
    const where =
      tipoConta && Object.values(TipoConta).includes(tipoConta as TipoConta)
        ? { tipoConta: tipoConta as TipoConta }
        : {};

    const usuarios = await prisma.usuario.findMany({
      where,
      orderBy: { createdAt: "desc" },
    });

    const safe = usuarios.map((user) => ({
      id: user.id,
      nome: user.nome,
      email: user.email,
      cidade: user.cidade,
      estado: user.estado,
      tipoPessoa: user.tipoPessoa,
      tipoConta: user.tipoConta,
      papeis: normalizeRoles(user.papeis, user.tipoConta),
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    }));

    return res.json(safe);
  } catch (error) {
    logError("auth.usuarios", error);
    return sendError(res, 500, "Erro ao listar usuários");
  }
});

export default router;
