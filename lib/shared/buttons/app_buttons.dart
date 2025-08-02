import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Différents types de boutons partagés
enum AppButtonStyle {
  primary,
  secondary,
  outline,
  text,
  icon,
  fab,
}

// Bouton principal partagé
class AppButton extends StatefulWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final AppButtonStyle style;
  final Color? color;
  final bool isEnabled;
  final double? width;
  final double? height;
  final String? subtitle;
  final bool showArrow;

  const AppButton({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.style = AppButtonStyle.primary,
    this.color,
    this.isEnabled = true,
    this.width,
    this.height,
    this.subtitle,
    this.showArrow = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.isEnabled;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: isEnabled
                ? (_) {
                    setState(() => _isPressed = true);
                    _controller.forward();
                  }
                : null,
            onTapUp: isEnabled
                ? (_) {
                    setState(() => _isPressed = false);
                    _controller.reverse();
                    widget.onTap?.call();
                  }
                : null,
            onTapCancel: isEnabled
                ? () {
                    setState(() => _isPressed = false);
                    _controller.reverse();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height ?? 56,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: _buildDecoration(theme, isDark, isEnabled),
              child: _buildContent(theme, isDark, isEnabled),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration(ThemeData theme, bool isDark, bool isEnabled) {
    final opacity = isEnabled ? 1.0 : 0.5;
    final defaultColor = widget.color ?? theme.colorScheme.primary;

    switch (widget.style) {
      case AppButtonStyle.primary:
        return BoxDecoration(
          color: _isPressed ? defaultColor.withAlpha(26) : defaultColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: defaultColor.withAlpha(128),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );

      case AppButtonStyle.secondary:
        return BoxDecoration(
          color: _isPressed ? defaultColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: defaultColor.withAlpha((opacity * 255).round()),
            width: 2,
          ),
        );

      case AppButtonStyle.outline:
        return BoxDecoration(
          color: _isPressed ? defaultColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: defaultColor.withAlpha((opacity * 255).round()),
            width: 1.5,
          ),
        );

      case AppButtonStyle.text:
        return BoxDecoration(
          color: _isPressed ? defaultColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        );

      case AppButtonStyle.icon:
        return BoxDecoration(
          color: _isPressed ? defaultColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: defaultColor.withAlpha((opacity * 255).round()),
            width: 1,
          ),
        );

      case AppButtonStyle.fab:
        return BoxDecoration(
          color: defaultColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: defaultColor.withAlpha(128),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  Widget _buildContent(ThemeData theme, bool isDark, bool isEnabled) {
    final defaultColor = widget.color ?? theme.colorScheme.primary;
    final textColor = widget.style == AppButtonStyle.primary
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    if (widget.style == AppButtonStyle.fab) {
      return Icon(
        widget.icon ?? Icons.add,
        color: Colors.white,
        size: 24,
      );
    }

    if (widget.style == AppButtonStyle.icon) {
      return Icon(
        widget.icon ?? Icons.star,
        color: defaultColor,
        size: 24,
      );
    }

    return Row(
      children: [
        if (widget.icon != null) ...[
          _buildIcon(defaultColor, isEnabled),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor.withAlpha(isEnabled ? 255 : 128),
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: textColor.withAlpha(isEnabled ? 179 : 77),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.showArrow)
          AnimatedRotation(
            turns: _isPressed ? 0.1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: textColor.withAlpha(isEnabled ? 153 : 77),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon(Color color, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.style == AppButtonStyle.primary
            ? Colors.white.withAlpha(26)
            : color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        widget.icon,
        color: widget.style == AppButtonStyle.primary ? Colors.white : color,
        size: 20,
      ),
    );
  }
}

// Bouton personnalisé pour les matières et unités - avec effets d'animation
class SubjectButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;

  const SubjectButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  @override
  State<SubjectButton> createState() => _SubjectButtonState();
}

class _SubjectButtonState extends State<SubjectButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onTap,
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _controller.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _controller.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _controller.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                decoration: BoxDecoration(
                  color:
                      _isPressed ? widget.color.withAlpha(204) : widget.color,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withAlpha(_isPressed ? 102 : 128),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 4),
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
                            widget.color.withAlpha(_isPressed ? 179 : 196),
                            widget.color,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                widget.color.withAlpha(_isPressed ? 102 : 128),
                            blurRadius: _isPressed ? 8 : 12,
                            offset: Offset(0, _isPressed ? 2 : 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          widget.icon,
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
                            widget.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.subtitle!,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(179),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isPressed ? 0.1 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Petit bouton pour les actions rapides
class CompactButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const CompactButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF2196F3),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
