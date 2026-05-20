import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/artist_card.dart';

const _generosFiltro = [
  'Todos', 'Sertanejo', 'Rock', 'Pagode', 'MPB', 'Jazz',
  'Eletrônica', 'Indie', 'Pop', 'Funk', 'Gospel', 'Forró',
];

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final _searchCtrl = TextEditingController();
  String _genero = 'Todos';
  bool _apenasDisponiveis = false;
  List<UserModel> _artists = [];

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_load);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_load);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _load() {
    setState(() {
      _artists = UserService.search(
        query: _searchCtrl.text.trim().isEmpty
            ? null
            : _searchCtrl.text.trim(),
        genero: _genero == 'Todos' ? null : _genero,
        disponivelApenas: _apenasDisponiveis ? true : null,
      );
      _artists.sort((a, b) {
        if (a.perfilPago && !b.perfilPago) return -1;
        if (!a.perfilPago && b.perfilPago) return 1;
        return a.nome.compareTo(b.nome);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(ctrl: _searchCtrl),
            _FilterBar(
              genero: _genero,
              apenasDisponiveis: _apenasDisponiveis,
              onGeneroChanged: (g) {
                setState(() => _genero = g);
                _load();
              },
              onDisponivelChanged: (v) {
                setState(() => _apenasDisponiveis = v);
                _load();
              },
            ),
            Expanded(
              child: _artists.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: _artists.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final artist = _artists[i];
                        return ArtistCard(
                          artist: artist,
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.artistDetail,
                            arguments: artist,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Artistas',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Encontre músicos locais',
            style: TextStyle(color: AppTheme.textMedium, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
            decoration: AppTheme.lightInputDecoration(
              hint: 'Buscar por nome, gênero ou cidade...',
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppTheme.textLight, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String genero;
  final bool apenasDisponiveis;
  final ValueChanged<String> onGeneroChanged;
  final ValueChanged<bool> onDisponivelChanged;

  const _FilterBar({
    required this.genero,
    required this.apenasDisponiveis,
    required this.onGeneroChanged,
    required this.onDisponivelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _generosFiltro.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final g = _generosFiltro[i];
              final active = g == genero;
              return GestureDetector(
                onTap: () => onGeneroChanged(g),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: active
                          ? AppTheme.primary
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      g,
                      style: TextStyle(
                        color: active ? Colors.white : AppTheme.textMedium,
                        fontSize: 12,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => onDisponivelChanged(!apenasDisponiveis),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: apenasDisponiveis
                      ? AppTheme.statusGreen.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: apenasDisponiveis
                        ? AppTheme.statusGreen
                        : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: apenasDisponiveis
                            ? AppTheme.statusGreen
                            : AppTheme.textLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Disponíveis agora',
                      style: TextStyle(
                        color: apenasDisponiveis
                            ? AppTheme.statusGreen
                            : AppTheme.textMedium,
                        fontSize: 12,
                        fontWeight: apenasDisponiveis
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_rounded,
              size: 36,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhum artista encontrado',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tente outros filtros',
            style: TextStyle(color: AppTheme.textMedium, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
