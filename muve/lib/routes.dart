import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'models/chat_model.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/artists/artist_detail_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/profile/settings_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const artistDetail = '/artist_detail';
  static const chat = '/chat';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        main: (_) => const MainScreen(),
        settings: (_) => const SettingsScreen(),
        artistDetail: (context) {
          final artist =
              ModalRoute.of(context)!.settings.arguments as UserModel;
          return ArtistDetailScreen(artist: artist);
        },
        chat: (context) {
          final room = ModalRoute.of(context)!.settings.arguments as ChatRoom;
          return ChatScreen(room: room);
        },
      };
}
