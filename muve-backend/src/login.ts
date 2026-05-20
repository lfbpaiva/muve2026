import { Router, Request, Response } from "express";
import { PrismaClient, TipoPessoa, TipoConta } from "@prisma/client";
import bcrypt from "bcryptjs";

const router = Router();
const prisma = new PrismaClient();

/**
 * POST /auth/register
 * Cadastro de usuário (ARTISTA ou CONTRATANTE)
 */
router.post("/register", async (req: Request, res: Response) => {
  try {
    const {
      nome,
      email,
      senha,
      telefone,
      tipoPessoa,
      cpf,
      cnpj,
      razaoSocial,
      tipoConta,
    } = req.body ?? {};

    // Campos básicos obrigatórios
    if (!nome || !email || !senha) {
      return res.status(400).json({
        success: false,
        message: "nome, email e senha são obrigatórios",
      });
    }

    // Validação do tipoConta (papel no app)
    if (!tipoConta || !["ARTISTA", "CONTRATANTE"].includes(tipoConta)) {
      return res.status(400).json({
        success: false,
        message: "tipoConta deve ser ARTISTA ou CONTRATANTE",
      });
    }

    // Validação do tipoPessoa (PF/PJ)
    if (!tipoPessoa || !["PF", "PJ"].includes(tipoPessoa)) {
      return res.status(400).json({
        success: false,
        message: 'tipoPessoa deve ser "PF" ou "PJ"',
      });
    }

    // Regras específicas para PF/PJ
    if (tipoPessoa === "PF" && !cpf) {
      return res.status(400).json({
        success: false,
        message: "CPF é obrigatório para PF",
      });
    }

    if (tipoPessoa === "PJ" && (!cnpj || !razaoSocial)) {
      return res.status(400).json({
        success: false,
        message: "CNPJ e razão social são obrigatórios para PJ",
      });
    }

    // Verifica se já existe usuário com esse email
    const existing = await prisma.usuario.findUnique({
      where: { email },
    });

    if (existing) {
      return res.status(409).json({
        success: false,
        message: "E-mail já cadastrado",
      });
    }

    // Gera hash da senha
    const hash = await bcrypt.hash(senha, 10);

    // Mapeia strings para enums do Prisma
    const tipoPessoaEnum =
      tipoPessoa === "PJ" ? TipoPessoa.PJ : TipoPessoa.PF;

    const tipoContaEnum =
      tipoConta === "CONTRATANTE"
        ? TipoConta.CONTRATANTE
        : TipoConta.ARTISTA;

    // Cria o usuário
    const user = await prisma.usuario.create({
      data: {
        nome,
        email,
        senha: hash,
        telefone,
        tipoPessoa: tipoPessoaEnum,
        tipoConta: tipoContaEnum,
        cpf: tipoPessoa === "PF" ? cpf : null,
        cnpj: tipoPessoa === "PJ" ? cnpj : null,
        razaoSocial: tipoPessoa === "PJ" ? razaoSocial : null,
      },
    });

    // Remove a senha antes de devolver
    const { senha: _password, ...safeUser } = user as any;

    return res.status(201).json({
      success: true,
      user: safeUser,
    });
  } catch (e: any) {
    console.error(e);

    // Erro de unique constraint (email/cpf/cnpj)
    if (String(e?.code) === "P2002") {
      return res.status(409).json({
        success: false,
        message: "Email/CPF/CNPJ já cadastrado",
      });
    }

    return res.status(500).json({
      success: false,
      message: "Erro interno",
    });
  }
});

/**
 * POST /auth/login
 * Login com email + senha
 */
router.post("/login", async (req: Request, res: Response) => {
  try {
    const { email, senha } = req.body ?? {};

    if (!email || !senha) {
      return res.status(400).json({
        success: false,
        message: "email e senha são obrigatórios",
      });
    }

    const user = await prisma.usuario.findUnique({
      where: { email },
    });

    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "Credenciais inválidas" });
    }

    const ok = await bcrypt.compare(senha, user.senha);
    if (!ok) {
      return res
        .status(401)
        .json({ success: false, message: "Credenciais inválidas" });
    }

    const { senha: _password, ...safeUser } = user as any;

    return res.json({
      success: true,
      user: safeUser, // aqui vem tipoPessoa e tipoConta também
    });
  } catch (e) {
    console.error(e);
    return res.status(500).json({
      success: false,
      message: "Erro interno",
    });
  }
});

/**
 * GET /auth/usuarios
 * Lista usuários (apenas para teste / DEV)
 * Exemplo:
 *   GET http://localhost:3000/auth/usuarios
 *   GET http://localhost:3000/auth/usuarios?tipoConta=ARTISTA
 */
router.get("/usuarios", async (req: Request, res: Response) => {
  try {
    const { tipoConta } = req.query as { tipoConta?: string };

    const where: any = {};

    if (tipoConta && ["ARTISTA", "CONTRATANTE"].includes(tipoConta)) {
      where.tipoConta = tipoConta as TipoConta;
    }

    const usuarios = await prisma.usuario.findMany({
      where,
      orderBy: { createdAt: "desc" },
    });

    const safe = usuarios.map((u: any) => {
      const { senha: _password, ...rest } = u;
      return rest;
    });

    return res.json(safe);
  } catch (e) {
    console.error(e);
    return res.status(500).json({
      success: false,
      message: "Erro ao listar usuários",
    });
  }
});

export default router;
