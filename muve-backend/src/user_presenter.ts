import { TipoConta, type Usuario } from "@prisma/client";

const appRoles = [TipoConta.ARTISTA, TipoConta.CONTRATANTE, TipoConta.ADMIN];

export function normalizeRoles(
  value: unknown,
  fallback?: TipoConta | null
): TipoConta[] {
  const roles = Array.isArray(value)
    ? value
        .map((role) => String(role).trim().toUpperCase())
        .filter((role): role is TipoConta =>
          appRoles.includes(role as TipoConta)
        )
    : [];

  if (roles.length === 0 && fallback) {
    roles.push(fallback);
  }

  return Array.from(new Set(roles));
}

export function userHasRole(
  user: Pick<Usuario, "tipoConta" | "papeis">,
  role: TipoConta
) {
  return normalizeRoles(user.papeis, user.tipoConta).includes(role);
}

export function toAuthenticatedUser(user: Usuario) {
  const { senha: _senha, ...safeUser } = user;

  return {
    ...safeUser,
    papeis: normalizeRoles(user.papeis, user.tipoConta),
  };
}

export function toPublicArtist(user: Usuario) {
  return {
    id: user.id,
    nome: user.nome,
    fotoPerfil: user.fotoPerfil,
    bio: user.bio,
    cidade: user.cidade,
    estado: user.estado,
    generos: user.generos,
    redesSociais: user.redesSociais,
    faixaCache: user.faixaCache,
    disponivelContratacao: user.disponivelContratacao,
    perfilPago: user.perfilPago,
    tipoPessoa: user.tipoPessoa,
    tipoConta: user.tipoConta,
    papeis: normalizeRoles(user.papeis, user.tipoConta),
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  };
}
