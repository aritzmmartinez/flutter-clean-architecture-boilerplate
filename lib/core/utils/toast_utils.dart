import 'package:flutter/material.dart';

class ToastUtils {
  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;

  static void init(BuildContext context) {
    _context = context;
  }

  static void showSuccess(String message) {
    _showTopSnackBar(
      message: message,
      backgroundColor: const Color(0xFF10B981), // Green
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(String message) {
    _showTopSnackBar(
      message: message,
      backgroundColor: const Color(0xFFEF4444), // Red
      icon: Icons.error_rounded,
    );
  }

  static void showInfo(String message) {
    _showTopSnackBar(
      message: message,
      backgroundColor: const Color(0xFF3B82F6), // Blue
      icon: Icons.info_rounded,
    );
  }

  static void showWarning(String message) {
    _showTopSnackBar(
      message: message,
      backgroundColor: const Color(0xFFF59E0B), // Orange
      icon: Icons.warning_rounded,
    );
  }

  static void _showTopSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    cancel();

    if (_context == null || !_context!.mounted) {
      debugPrint('ToastUtils: No context available. Message: $message');
      return;
    }

    try {
      // Crear el overlay entry
      _overlayEntry = OverlayEntry(
        builder: (context) => _TopSnackBar(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          onDismiss: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
        ),
      );

      Overlay.of(_context!).insert(_overlayEntry!);

      Future.delayed(const Duration(seconds: 3), () {
        if (_overlayEntry != null) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      });
    } catch (e) {
      debugPrint('SnackBar error: $e - Message: $message');
    }
  }

  static void cancel() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class _TopSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const _TopSnackBar({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -5) {
                    _dismiss();
                  }
                },
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.close,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
