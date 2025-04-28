import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';

class GlowingAvatar extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final Color glowColor;
  final bool animate;
  final int level;
  final String playerClass;

  const GlowingAvatar({
    Key? key,
    this.imageUrl,
    required this.size,
    required this.level,
    required this.playerClass,
    this.glowColor = Colors.blue,
    this.animate = true,
  }) : super(key: key);

  @override
  _GlowingAvatarState createState() => _GlowingAvatarState();
}

class _GlowingAvatarState extends State<GlowingAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  Color get _avatarBorderColor {
    switch (widget.playerClass) {
      case 'E-Class':
        return AppColors.classE;
      case 'D-Class':
        return AppColors.classD;
      case 'C-Class':
        return AppColors.classC;
      case 'B-Class':
        return AppColors.classB;
      case 'A-Class':
        return AppColors.classA;
      case 'S-Class':
        return AppColors.classS;
      case 'SS-Class':
        return AppColors.classSS;
      default:
        return AppColors.classE;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (!widget.animate) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.animate
                    ? widget.glowColor.withOpacity(0.3 * _glowAnimation.value)
                    : widget.glowColor.withOpacity(0.4),
                blurRadius: widget.animate
                    ? 15.0 * _glowAnimation.value
                    : 10.0,
                spreadRadius: widget.animate
                    ? 2.0 * _glowAnimation.value
                    : 2.0,
              ),
            ],
          ),
          child: _buildAvatarWithRank(),
        );
      },
    );
  }

  Widget _buildAvatarWithRank() {
    return Stack(
      children: [
        Center(
          child: Container(
            width: widget.size * 0.9,
            height: widget.size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _avatarBorderColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _avatarBorderColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildDefaultAvatar();
                      },
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkBackground,
              border: Border.all(
                color: _avatarBorderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _avatarBorderColor.withOpacity(0.7),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.level.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.size * 0.15,
                  shadows: [
                    Shadow(
                      color: _avatarBorderColor,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.darkPurple,
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.white70,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}