import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

enum ButtonType { primary, secondary, danger, success }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.fullWidth = false,
    this.height = 48.0,
    this.icon,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onPressed != null && !widget.isLoading) {
            _animationController.forward();
          }
        },
        onTapUp: (_) {
          if (widget.onPressed != null && !widget.isLoading) {
            _animationController.reverse();
            widget.onPressed!();
          }
        },
        onTapCancel: () {
          if (widget.onPressed != null && !widget.isLoading) {
            _animationController.reverse();
          }
        },
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getButtonGradient(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (widget.onPressed != null)
                BoxShadow(
                  color: _getButtonShadowColor(),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: widget.isLoading
                    ? _buildLoadingIndicator()
                    : Row(
                        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: _getButtonTextStyle(),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 2.0,
      ),
    );
  }

  List<Color> _getButtonGradient() {
    if (widget.onPressed == null) {
      return [AppColors.darkGrey, AppColors.darkGrey];
    }

    switch (widget.type) {
      case ButtonType.primary:
        return [AppColors.neonBlue, AppColors.purpleAccent];
      case ButtonType.secondary:
        return [AppColors.deepBlue, AppColors.darkPurple];
      case ButtonType.danger:
        return [AppColors.dangerRed, AppColors.dangerDarkRed];
      case ButtonType.success:
        return [AppColors.successGreen, AppColors.successDarkGreen];
    }
  }

  Color _getButtonShadowColor() {
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.neonBlue.withOpacity(0.4);
      case ButtonType.secondary:
        return AppColors.deepBlue.withOpacity(0.3);
      case ButtonType.danger:
        return AppColors.dangerRed.withOpacity(0.4);
      case ButtonType.success:
        return AppColors.successGreen.withOpacity(0.4);
    }
  }

  TextStyle _getButtonTextStyle() {
    return widget.onPressed == null
        ? AppTextStyles.buttonTextDisabled
        : AppTextStyles.buttonText;
  }
}