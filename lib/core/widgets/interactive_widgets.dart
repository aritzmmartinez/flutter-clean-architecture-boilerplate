import 'package:flutter/material.dart';
import '../utils/haptic_utils.dart';
import '../theme/app_theme.dart';

class AnimatedScaleButton extends StatefulWidget {
  const AnimatedScaleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.hapticFeedback = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double scaleDown;
  final Duration duration;
  final bool hapticFeedback;

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
      if (widget.hapticFeedback) {
        HapticUtils.light();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

class InteractiveCard extends StatefulWidget {
  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12.0,
    this.elevation = 0,
    this.enableHaptic = true,
    this.scaleOnTap = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final bool enableHaptic;
  final bool scaleOnTap;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
      if (widget.enableHaptic) {
        HapticUtils.light();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cardContent = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Material(
          elevation: _elevationAnimation.value,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: theme.cardColor,
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: widget.child,
          ),
        );
      },
    );

    if (widget.scaleOnTap && widget.onTap != null) {
      cardContent = ScaleTransition(scale: _scaleAnimation, child: cardContent);
    }

    return Container(
      margin: widget.margin,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: cardContent,
      ),
    );
  }
}

class RippleButton extends StatelessWidget {
  const RippleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool enableHaptic;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppTheme.limeGreen,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: () {
          if (enableHaptic) {
            HapticUtils.medium();
          }
          onPressed?.call();
        },
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.white.withValues(alpha: 0.3),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Container(padding: padding, child: child),
      ),
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color,
    this.rotateOnTap = true,
    this.scaleOnTap = true,
    this.enableHaptic = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final bool rotateOnTap;
  final bool scaleOnTap;
  final bool enableHaptic;

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      if (widget.enableHaptic) {
        HapticUtils.light();
      }
      _controller.forward().then((_) => _controller.reverse());
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Widget iconWidget = Icon(
            widget.icon,
            size: widget.size,
            color: widget.color ?? AppTheme.darkTeal,
          );

          if (widget.rotateOnTap) {
            iconWidget = Transform.rotate(
              angle: _rotationAnimation.value,
              child: iconWidget,
            );
          }

          if (widget.scaleOnTap) {
            iconWidget = Transform.scale(
              scale: _scaleAnimation.value,
              child: iconWidget,
            );
          }

          return iconWidget;
        },
      ),
    );
  }
}

class AnimatedFAB extends StatefulWidget {
  const AnimatedFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? heroTag;

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RotationTransition(
        turns: _rotationAnimation,
        child: widget.label != null
            ? FloatingActionButton.extended(
                onPressed: () {
                  HapticUtils.medium();
                  widget.onPressed();
                },
                backgroundColor: widget.backgroundColor ?? AppTheme.limeGreen,
                foregroundColor: widget.foregroundColor ?? AppTheme.darkTeal,
                icon: Icon(widget.icon),
                label: Text(widget.label!),
                heroTag: widget.heroTag,
              )
            : FloatingActionButton(
                onPressed: () {
                  HapticUtils.medium();
                  widget.onPressed();
                },
                backgroundColor: widget.backgroundColor ?? AppTheme.limeGreen,
                foregroundColor: widget.foregroundColor ?? AppTheme.darkTeal,
                heroTag: widget.heroTag,
                child: Icon(widget.icon),
              ),
      ),
    );
  }
}

class AnimatedSwitch extends StatelessWidget {
  const AnimatedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.enableHaptic = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final bool enableHaptic;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (newValue) {
        if (enableHaptic) {
          HapticUtils.light();
        }
        onChanged(newValue);
      },
      activeColor: activeColor ?? AppTheme.limeGreen,
      activeTrackColor: (activeColor ?? AppTheme.limeGreen).withValues(
        alpha: 0.5,
      ),
    );
  }
}
