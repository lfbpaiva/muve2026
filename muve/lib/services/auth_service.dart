import '../models/user_model.dart';
import 'user_service.dart';

class AuthService {
  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static Future<({bool success, String? error})> login(
      String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = UserService.getByEmail(email);
    if (user == null) {
      return (success: false, error: 'E-mail não encontrado');
    }
    if (!UserService.checkSenha(email, senha)) {
      return (success: false, error: 'Senha incorreta');
    }

    currentUser = user;
    return (success: true, error: null);
  }

  static Future<({bool success, String? error})> register({
    required String nome,
    required String email,
    required String senha,
    required String cidade,
    required String estado,
    required List<String> papeis,
    String? telefone,
    String? cpf,
    String? cnpj,
    List<String> generos = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (UserService.getByEmail(email) != null) {
      return (success: false, error: 'Este e-mail já está cadastrado');
    }

    final newUser = UserModel(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      nome: nome,
      email: email,
      telefone: telefone,
      cpf: cpf,
      cnpj: cnpj,
      cidade: cidade,
      estado: estado,
      papeis: papeis,
      generos: generos,
      criadoEm: DateTime.now(),
    );

    UserService.add(newUser, senha);
    currentUser = newUser;
    return (success: true, error: null);
  }

  static void logout() {
    currentUser = null;
  }

  static void updateCurrentUser(UserModel updated) {
    currentUser = updated;
    UserService.update(updated);
  }
}
