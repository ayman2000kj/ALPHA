import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// أنواع مختلفة من الأزرار
enum ButtonStyle {
  elevated,
  filled,
  outlined,
  glass,
  gradient,
}

/// الحالة الحالية للزر
enum ButtonState {
  normal,
  pressed,
  disabled,
  loading,
}

/// الزر الأساسي المحسّن مع تحسينات جديدة
class ModernButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool showArrow;
  final String? subtitle;
  final bool isEnabled;
  final double? width;
  final ButtonStyle style;
  final bool isLoading;
  final Duration animationDuration;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? customShadows;
  final Gradient? gradient;

  const ModernButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF2196F3),
    this.showArrow = true,
    this.subtitle,
    this.isEnabled = true,
    this.width,
    this.style = ButtonStyle.elevated,
    this.isLoading = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius = 24.0,
    this.padding,
    this.customShadows,
    this.gradient,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  ButtonState _buttonState = ButtonState.normal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _updateButtonState();
  }

  @override
  void didUpdateWidget(ModernButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateButtonState();
  }

  void _updateButtonState() {
    if (widget.isLoading) {
      _buttonState = ButtonState.loading;
    } else if (!widget.isEnabled) {
      _buttonState = ButtonState.disabled;
    } else {
      _buttonState = ButtonState.normal;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = widget.isEnabled && !widget.isLoading;

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _opacityAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: isEnabled
                  ? (_) {
                      setState(() => _buttonState = ButtonState.pressed);
                      _controller.forward();
                    }
                  : null,
              onTapUp: isEnabled
                  ? (_) {
                      setState(() => _buttonState = ButtonState.normal);
                      _controller.reverse();
                      widget.onTap();
                    }
                  : null,
              onTapCancel: isEnabled
                  ? () {
                      setState(() => _buttonState = ButtonState.normal);
                      _controller.reverse();
                    }
                  : null,
              child: AnimatedContainer(
                duration: widget.animationDuration,
                width: widget.width,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: widget.padding ?? const EdgeInsets.all(20),
                decoration: _buildDecoration(isDark, isEnabled),
                child: _buildContent(isDark, isEnabled),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration(bool isDark, bool isEnabled) {
    final opacity = isEnabled ? 1.0 : 0.5;
    final baseColor =
        widget.color.withValues(alpha: (opacity * 255).toDouble());

    switch (widget.style) {
      case ButtonStyle.elevated:
        return BoxDecoration(
          color: _buttonState == ButtonState.pressed
              ? baseColor.withValues(alpha: 26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: baseColor, width: 2),
          boxShadow: widget.customShadows ??
              [
                BoxShadow(
                  color: baseColor.withValues(alpha: 130),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
        );

      case ButtonStyle.filled:
        return BoxDecoration(
          color: _buttonState == ButtonState.pressed
              ? baseColor.withValues(alpha: 26)
              : baseColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.customShadows ??
              [
                BoxShadow(
                  color: baseColor.withValues(alpha: 130),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
        );

      case ButtonStyle.outlined:
        return BoxDecoration(
          color: _buttonState == ButtonState.pressed
              ? baseColor.withValues(alpha: 26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: baseColor, width: 2),
        );

      case ButtonStyle.glass:
        return BoxDecoration(
          color: _buttonState == ButtonState.pressed
              ? baseColor.withValues(alpha: 26)
              : Colors.white.withValues(alpha: 10),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: baseColor.withValues(alpha: 77)),
          boxShadow: widget.customShadows ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 26),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
        );

      case ButtonStyle.gradient:
        return BoxDecoration(
          gradient: widget.gradient ??
              LinearGradient(
                colors: [
                  baseColor,
                  baseColor.withValues(alpha: 204),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.customShadows ??
              [
                BoxShadow(
                  color: baseColor.withValues(alpha: 130),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
        );
    }
  }

  Widget _buildContent(bool isDark, bool isEnabled) {
    final textColor = _getTextColor(isDark, isEnabled);

    return Row(
      children: [
        _buildIcon(isEnabled),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor.withValues(alpha: isEnabled ? 255 : 128),
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: textColor.withValues(alpha: isEnabled ? 179 : 77),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.showArrow && !widget.isLoading)
          AnimatedRotation(
            turns: _buttonState == ButtonState.pressed ? 0.1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: textColor.withValues(alpha: isEnabled ? 153 : 77),
            ),
          ),
        if (widget.isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor.withValues(alpha: isEnabled ? 153 : 77),
              ),
            ),
          ),
      ],
    );
  }

  Color _getTextColor(bool isDark, bool isEnabled) {
    switch (widget.style) {
      case ButtonStyle.filled:
      case ButtonStyle.gradient:
        return Colors.white;
      default:
        return isDark ? Colors.white : Colors.black87;
    }
  }

  Widget _buildIcon(bool isEnabled) {
    final iconColor = _getIconColor(isEnabled);
    final iconWidget = Icon(
      widget.icon,
      color: iconColor,
      size: 28,
    );

    if (widget.style == ButtonStyle.filled ||
        widget.style == ButtonStyle.gradient) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: isEnabled ? 255 : 128),
          borderRadius: BorderRadius.circular(16),
        ),
        child: iconWidget,
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: isEnabled ? 255 : 128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color.withValues(alpha: 77)),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 130),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: iconWidget,
    );
  }

  Color _getIconColor(bool isEnabled) {
    switch (widget.style) {
      case ButtonStyle.filled:
      case ButtonStyle.gradient:
        return Colors.white;
      default:
        return widget.color.withValues(alpha: isEnabled ? 255 : 128);
    }
  }
}

/// زر صغير للإجراءات السريعة مع تحسينات
class CompactButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool isEnabled;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CompactButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF2196F3),
    this.isEnabled = true,
    this.borderRadius = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isEnabled ? 26 : 10),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: color.withValues(alpha: isEnabled ? 77 : 40),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: color.withValues(alpha: isEnabled ? 255 : 128),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: color.withValues(alpha: isEnabled ? 255 : 128),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر FAB مخصص مع تحسينات
class ModernFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final String? tooltip;
  final bool isEnabled;
  final double size;
  final Gradient? gradient;

  const ModernFAB({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF2196F3),
    this.tooltip,
    this.isEnabled = true,
    this.size = 56.0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isEnabled ? onTap : null,
      tooltip: tooltip,
      backgroundColor: Colors.transparent,
      elevation: 8,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient ??
              LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 204),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }
}

/// زر مخصص للمواد والوحدات مع تحسينات
class SubjectUnitButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;
  final bool isEnabled;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? customShadows;

  const SubjectUnitButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.isEnabled = true,
    this.borderRadius = 22.0,
    this.padding,
    this.customShadows,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isEnabled ? 255 : 128),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: customShadows ??
                [
                  BoxShadow(
                    color: color.withValues(alpha: isEnabled ? 130 : 60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: isEnabled ? 196 : 128),
                      color.withValues(alpha: isEnabled ? 255 : 128),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: isEnabled ? 130 : 60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSurface.withValues(
                                  alpha: isEnabled ? 255 : 128,
                                ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: isEnabled ? 179 : 77),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).colorScheme.primary.withValues(
                      alpha: isEnabled ? 255 : 128,
                    ),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زر عادي محسن مع تحسينات
class ModernElevatedButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool isEnabled;
  final bool isLoading;
  final Gradient? gradient;

  const ModernElevatedButton({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.isEnabled = true,
    this.isLoading = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = this.isEnabled && !isLoading;

    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient != null
              ? Colors.transparent
              : (backgroundColor ?? theme.colorScheme.primary),
          foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: gradient != null
            ? Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: borderRadius ?? BorderRadius.circular(16),
                ),
                child: _buildButtonContent(theme),
              )
            : _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? theme.colorScheme.onPrimary,
              ),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// زر محسن مع حدود
class ModernOutlinedButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final bool isLoading;

  const ModernOutlinedButton({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.borderColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = this.isEnabled && !isLoading;

    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor?.withValues(alpha: isEnabled ? 255 : 128) ??
              theme.colorScheme.outline
                  .withValues(alpha: isEnabled ? 255 : 128),
          width: 1.5,
        ),
      ),
      child: OutlinedButton(
        onPressed: isEnabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          foregroundColor:
              foregroundColor?.withValues(alpha: isEnabled ? 255 : 128) ??
                  theme.colorScheme.onSurface
                      .withValues(alpha: isEnabled ? 255 : 128),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
          side: BorderSide.none,
        ),
        child: _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? theme.colorScheme.onSurface,
              ),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// زر نصي محسن
class ModernTextButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final bool isLoading;

  const ModernTextButton({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = this.isEnabled && !isLoading;

    return Container(
      width: width,
      height: height ?? 56,
      child: TextButton(
        onPressed: isEnabled ? onTap : null,
        style: TextButton.styleFrom(
          foregroundColor:
              foregroundColor?.withValues(alpha: isEnabled ? 255 : 128) ??
                  theme.colorScheme.primary
                      .withValues(alpha: isEnabled ? 255 : 128),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
        ),
        child: _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? theme.colorScheme.primary,
              ),
            ),
          )
        else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
