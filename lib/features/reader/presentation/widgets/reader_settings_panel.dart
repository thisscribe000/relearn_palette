import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../reader_settings.dart';

/// "Aa" reading settings sheet. Controls font size, typeface, line spacing,
/// page appearance and brightness. Local mock state only — nothing persists.
class ReaderSettingsPanel extends StatefulWidget {
  const ReaderSettingsPanel({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  final ReaderSettings initial;
  final ValueChanged<ReaderSettings> onChanged;

  @override
  State<ReaderSettingsPanel> createState() => _ReaderSettingsPanelState();
}

class _ReaderSettingsPanelState extends State<ReaderSettingsPanel> {
  late ReaderSettings _settings = widget.initial;

  ReaderPalette get _palette => paletteFor(_settings.appearance);

  void _update(ReaderSettings next) {
    setState(() => _settings = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Reading settings',
            style: TextStyle(
              fontFamily: AppFonts.serif,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: palette.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Adjust how the text looks',
            style: TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 12,
              color: palette.secondary,
            ),
          ),
          const SizedBox(height: 18),

          _sectionLabel('Font size', palette.secondary),
          Row(
            children: [
              Text(
                'A',
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 13,
                  color: palette.secondary,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: AppColors.mutedGold,
                    inactiveTrackColor: palette.secondary.withValues(
                      alpha: 0.25,
                    ),
                    thumbColor: AppColors.mutedGold,
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: _settings.fontSize,
                    min: 16,
                    max: 28,
                    divisions: 12,
                    label: '${_settings.fontSize.round()}',
                    onChanged: (v) => _update(_settings.copyWith(fontSize: v)),
                  ),
                ),
              ),
              Text(
                'A',
                style: TextStyle(
                  fontFamily: AppFonts.serif,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: palette.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _sectionLabel('Typeface', palette.secondary),
          Row(
            children: [
              _optionPill(
                'Serif',
                selected: _settings.serif,
                palette: palette,
                onTap: () => _update(_settings.copyWith(serif: true)),
              ),
              const SizedBox(width: 8),
              _optionPill(
                'Sans',
                selected: !_settings.serif,
                palette: palette,
                onTap: () => _update(_settings.copyWith(serif: false)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _sectionLabel('Line spacing', palette.secondary),
          Row(
            children: [
              _optionPill(
                'Compact',
                selected: _settings.lineSpacing < 1.6,
                palette: palette,
                onTap: () => _update(_settings.copyWith(lineSpacing: 1.35)),
              ),
              const SizedBox(width: 8),
              _optionPill(
                'Relaxed',
                selected: _settings.lineSpacing >= 1.6,
                palette: palette,
                onTap: () => _update(_settings.copyWith(lineSpacing: 1.8)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _sectionLabel('Page', palette.secondary),
          Row(
            children: [
              _swatch(
                appearance: ReaderAppearance.paper,
                label: 'Paper',
                selected: _settings.appearance == ReaderAppearance.paper,
                palette: palette,
              ),
              const SizedBox(width: 10),
              _swatch(
                appearance: ReaderAppearance.ivory,
                label: 'Ivory',
                selected: _settings.appearance == ReaderAppearance.ivory,
                palette: palette,
              ),
              const SizedBox(width: 10),
              _swatch(
                appearance: ReaderAppearance.deep,
                label: 'Deep',
                selected: _settings.appearance == ReaderAppearance.deep,
                palette: palette,
              ),
            ],
          ),
          const SizedBox(height: 14),

          _sectionLabel('Brightness', palette.secondary),
          Row(
            children: [
              const Icon(
                Icons.brightness_5_rounded,
                size: 18,
                color: AppColors.mutedGold,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    activeTrackColor: AppColors.mutedGold,
                    inactiveTrackColor: palette.secondary.withValues(
                      alpha: 0.25,
                    ),
                    thumbColor: AppColors.mutedGold,
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: _settings.brightness,
                    max: 0.55,
                    onChanged: (v) =>
                        _update(_settings.copyWith(brightness: v)),
                  ),
                ),
              ),
              const Icon(
                Icons.brightness_4_rounded,
                size: 18,
                color: AppColors.secondaryText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.sans,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: color,
        ),
      ),
    );
  }

  Widget _optionPill(
    String label, {
    required bool selected,
    required ReaderPalette palette,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? palette.surface : Colors.transparent,
          border: Border.all(
            color: selected
                ? AppColors.mutedGold.withValues(alpha: 0.8)
                : palette.secondary.withValues(alpha: 0.35),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? palette.ink : palette.secondary,
          ),
        ),
      ),
    );
  }

  Widget _swatch({
    required ReaderAppearance appearance,
    required String label,
    required bool selected,
    required ReaderPalette palette,
  }) {
    final swatchPalette = paletteFor(appearance);
    final selectedColor = selected ? AppColors.mutedGold : Colors.transparent;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _update(_settings.copyWith(appearance: appearance)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 56,
              decoration: BoxDecoration(
                color: swatchPalette.background,
                border: Border.all(
                  color: selected
                      ? AppColors.mutedGold
                      : palette.secondary.withValues(alpha: 0.35),
                  width: selected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Aa',
                  style: TextStyle(
                    fontFamily: AppFonts.serif,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: swatchPalette.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? palette.ink : palette.secondary,
              ),
            ),
            const SizedBox(height: 3),
            Container(width: 20, height: 2, color: selectedColor),
          ],
        ),
      ),
    );
  }
}
