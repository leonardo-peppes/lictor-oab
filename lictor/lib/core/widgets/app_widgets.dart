// lib/core/widgets/app_widgets.dart
// Componentes reutilizáveis do design system Lictor

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Logo Lictor ──────────────────────────────────────────────────────────────
class LictorLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const LictorLogo({
    super.key,
    this.size = 1.0,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "L" geométrico estilizado
        Container(
          width: 48 * size,
          height: 48 * size,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.silver, width: 1.5 * size),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Reflexo metálico
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: (48 * size) * 0.4,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x20FFFFFF),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'L',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 28 * size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12 * size),
        Text(
          'LICTOR',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 22 * size,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 10 * size,
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: 4 * size),
          Text(
            'PERFORMANCE JURÍDICA',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 9 * size,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
              letterSpacing: 4 * size,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Premium Lock Badge ───────────────────────────────────────────────────────
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.premiumGold.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 10,
            color: AppColors.premiumGold,
          ),
          const SizedBox(width: 4),
          Text(
            'PREMIUM',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────
class LictorProgressBar extends StatelessWidget {
  final double progress; // 0.0 a 1.0
  final int current;
  final int total;

  const LictorProgressBar({
    super.key,
    required this.progress,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Questão $current de $total',
              style: AppTextStyles.caption,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.silver,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.silver),
            minHeight: 2,
          ),
        ),
      ],
    );
  }
}

// ─── Difficulty Badge ─────────────────────────────────────────────────────────
class DifficultyBadge extends StatelessWidget {
  final String difficulty; // 'easy', 'medium', 'hard'

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (difficulty) {
      case 'easy':
        label = 'BÁSICO';
        color = const Color(0xFF4CAF50);
        break;
      case 'hard':
        label = 'AVANÇADO';
        color = const Color(0xFFE57373);
        break;
      default:
        label = 'MÉDIO';
        color = AppColors.silver;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ─── Premium Modal ────────────────────────────────────────────────────────────
void showPremiumModal(BuildContext context, {String? featureName}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.premiumGold.withOpacity(0.5)),
            ),
            child: Icon(
              Icons.lock_outline,
              size: 16,
              color: AppColors.premiumGold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'RECURSO PREMIUM',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.premiumGold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Desbloqueie o modo completo e treine como quem já vai passar.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to premium screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.background,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'ASSINAR PREMIUM',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Não agora',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textTertiary),
            const SizedBox(height: 12),
          ],
          Text(value, style: AppTextStyles.headlineLarge),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelLarge,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppTextStyles.caption),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ─── Locked Feature Card ──────────────────────────────────────────────────────
class LockedFeatureCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const LockedFeatureCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.locked,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, size: 16, color: AppColors.textTertiary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: AppTextStyles.bodyMedium),
            ),
            const PremiumBadge(),
          ],
        ),
      ),
    );
  }
}
