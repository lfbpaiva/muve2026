import 'package:flutter/material.dart';
import '../../constants/music_genres.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/artist_card.dart';
import '../../widgets/muve_feedback.dart';

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
  bool _loading = false;
  String? _error;
  int _requestSerial = 0;

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

  Future<void> _load() async {
    final requestId = ++_requestSerial;
    final query = _searchCtrl.text.trim();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final artists = await UserService.search(
        query: query.isEmpty ? null : query,
        genero: _genero == 'Todos' ? null : _genero,
        disponivelApenas: _apenasDisponiveis ? true : null,
      );

      if (!mounted || requestId != _requestSerial) return;
      setState(() {
        _artists = artists;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || requestId != _requestSerial) return;
      setState(() {
        _artists = [];
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Widget _buildArtistsBody() {
    if (_loading) {
      return const MuveLoadingState(
        label: 'Carregando artistas...',
      );
    }

    if (_error != null) {
      return MuveErrorState(
        title: 'Não foi possível carregar os artistas',
        message: _error!,
        onRetry: _load,
      );
    }

    if (_artists.isEmpty) {
      return const MuveEmptyState(
        icon: Icons.person_search_rounded,
        title: 'Nenhum artista encontrado',
        message: 'Ajuste os filtros para encontrar outros profissionais.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      itemCount: _artists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
    );
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
            Expanded(child: _buildArtistsBody()),
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
            itemCount: musicGenreFilters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final g = musicGenreFilters[i];
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
                      color:
                          active ? AppTheme.primary : const Color(0xFFD1D5DB),
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
