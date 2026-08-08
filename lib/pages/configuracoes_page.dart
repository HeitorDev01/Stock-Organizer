import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../theme/theme.dart';
import '../widgets/ui/app_card.dart';
import '../widgets/ui/responsive.dart';
import '../widgets/ui/section_header.dart';

/// Preferências de apresentação.
///
/// Guarda apenas aparência e nome de exibição na box `settings`; não toca em
/// `produtos` nem em nenhuma regra de negócio.
class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late final Box _settingsBox;
  late final TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settings');
    _nomeController = TextEditingController(
      text: (_settingsBox.get('userName') as String?) ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  ThemeController get _themeController => AppThemeScope.of(context);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentContainer(
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SectionHeader(
              eyebrow: 'Preferências',
              title: 'Aparência',
            ),
            AppCard(
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: _themeController,
                builder: (BuildContext context, ThemeMode mode, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Tema',
                        style: context.text.cardTitle.copyWith(
                          color: context.tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'A paleta é monocromática nos dois modos — muda o '
                        'sentido do contraste, não a cor.',
                        style: context.text.bodySmall!.copyWith(
                          color: context.tokens.textTertiary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final ThemeMode option in ThemeMode.values)
                        _ThemeOption(
                          mode: option,
                          selected: mode == option,
                          onTap: () => _themeController.set(option),
                        ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            const SectionHeader(
              eyebrow: 'Conta',
              title: 'Identificação',
            ),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Nome de exibição',
                    style: context.text.cardTitle.copyWith(
                      color: context.tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Usado na saudação do topo e nas iniciais do avatar.',
                    style: context.text.bodySmall!.copyWith(
                      color: context.tokens.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Gestor',
                      filled: true,
                      fillColor: context.tokens.surfaceMuted,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        size: AppIconSize.md,
                      ),
                    ),
                    onChanged: (String value) =>
                        _settingsBox.put('userName', value.trim()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            const SectionHeader(
              eyebrow: 'Sobre',
              title: 'Stock Organize',
            ),
            AppCard(
              tone: AppCardTone.muted,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _AboutRow(label: 'Versão', value: '1.0.0'),
                  const SizedBox(height: AppSpacing.xs),
                  _AboutRow(label: 'Armazenamento', value: 'Hive (local)'),
                  const SizedBox(height: AppSpacing.xs),
                  _AboutRow(label: 'Tipografia', value: 'Poppins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  static const Map<ThemeMode, (String, String, IconData)> _meta =
      <ThemeMode, (String, String, IconData)>{
    ThemeMode.system: (
      'Automático',
      'Acompanha o sistema',
      Icons.brightness_auto_outlined,
    ),
    ThemeMode.light: ('Claro', 'Fundo cinza-claro', Icons.light_mode_outlined),
    ThemeMode.dark: ('Escuro', 'Fundo quase-preto', Icons.dark_mode_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (String title, String subtitle, IconData icon) = _meta[mode]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        tone: selected ? AppCardTone.inverse : AppCardTone.muted,
        borderRadius: AppRadii.nested,
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: AppIconSize.md,
              color: selected ? t.iconInverse : t.iconSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: context.text.titleMedium!.copyWith(
                      color: selected ? t.textInverse : t.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: context.text.bodySmall!.copyWith(
                      color: selected
                          ? t.textInverseSecondary
                          : t.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_outlined,
                size: AppIconSize.md,
                color: t.iconInverse,
              ),
          ],
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: context.text.bodyMedium!.copyWith(
            color: context.tokens.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.text.titleSmall!.copyWith(
            color: context.tokens.textPrimary,
          ),
        ),
      ],
    );
  }
}
