import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';

class AppAnimations {
  // Animation durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 600);
  static const Duration longDuration = Duration(milliseconds: 1200);

  // Animation curves
  static const Curve easeCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeInOutQuart;
  
  // Common animations

  /// Slide in from bottom animation
  static Animation<Offset> slideInFromBottom(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: easeCurve,
    ));
  }

  /// Slide in from top animation
  static Animation<Offset> slideInFromTop(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: easeCurve,
    ));
  }

  /// Fade in animation
  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: easeCurve,
    ));
  }

  /// Scale animation
  static Animation<double> scale(AnimationController controller, {double begin = 0.8, double end = 1.0}) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: easeCurve,
    ));
  }

  /// Pulse animation
  static Animation<double> pulse(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: controller,
      curve: easeCurve,
    ));
  }

  /// Animated task completion widget
  static Widget buildTaskCompletionAnimation(BuildContext context, Widget child) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: mediumDuration,
      builder: (context, double value, Widget? child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Specific animations

  /// Level up glow animation
  static Widget buildLevelUpGlow(BuildContext context, {required Widget child, required bool isActive}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isActive ? 1.0 : 0.0),
      duration: longDuration,
      curve: bounceCurve,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.levelUpGlow.withOpacity(value * 0.7),
                blurRadius: 20 * value,
                spreadRadius: 10 * value,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }

  /// Class upgrade animation
  static Widget buildClassUpgradeAnimation(BuildContext context, {required Widget child, required bool isActive, required String className}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isActive ? 1.0 : 0.0),
      duration: longDuration,
      curve: sharpCurve,
      builder: (context, value, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background flash
            Opacity(
              opacity: value > 0.8 ? (1.0 - value) * 5 : value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      getClassColor(className).withOpacity(0.8),
                      getClassColor(className).withOpacity(0.0),
                    ],
                    radius: 1.0 + value,
                  ),
                ),
              ),
            ),
            
            // Particle effect
            if (value > 0.3 && value < 0.9)
              ..._buildParticles(20, value, getClassColor(className)),
            
            // Scale and shake the main content
            Transform.translate(
              offset: isActive && value > 0.3 && value < 0.7
                  ? Offset(
                      math.sin(value * 50) * 5 * (1 - value),
                      math.cos(value * 50) * 5 * (1 - value),
                    )
                  : Offset.zero,
              child: Transform.scale(
                scale: 1.0 + (value * 0.2),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Helper to build particles for class upgrade animation
  static List<Widget> _buildParticles(int count, double animValue, Color color) {
    final List<Widget> particles = [];
    final random = math.Random(42); // Fixed seed for consistent pattern
    
    for (int i = 0; i < count; i++) {
      final double size = random.nextDouble() * 10 + 5;
      final double angle = random.nextDouble() * 2 * math.pi;
      final double distance = random.nextDouble() * 150 * animValue;
      final double opacity = (1 - animValue) * random.nextDouble();
      
      final double dx = math.cos(angle) * distance;
      final double dy = math.sin(angle) * distance;
      
      particles.add(
        Positioned(
          left: dx,
          top: dy,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }
    
    return particles;
  }
  
  /// Death animation
  static Widget buildDeathAnimation(BuildContext context, {required Widget child, required bool isActive}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isActive ? 1.0 : 0.0),
      duration: longDuration,
      curve: Curves.easeInQuart,
      builder: (context, value, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Background darkening
            Container(
              color: Colors.black.withOpacity(value * 0.7),
            ),
            
            // Main content with desaturation and scale
            ColorFiltered(
              colorFilter: ColorFilter.matrix([
                0.33 + 0.67 * (1 - value), 0.33 * value, 0.33 * value, 0, 0,
                0.33 * value, 0.33 + 0.67 * (1 - value), 0.33 * value, 0, 0,
                0.33 * value, 0.33 * value, 0.33 + 0.67 * (1 - value), 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Transform.scale(
                scale: 1.0 - (value * 0.1),
                child: child,
              ),
            ),
            
            // Broken heart overlay
            if (value > 0.5)
              Center(
                child: Opacity(
                  opacity: (value - 0.5) * 2,
                  child: Icon(
                    Icons.heart_broken,
                    color: Colors.red.withOpacity(0.8),
                    size: 100 + (value * 50),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Task completion animation
 static Widget buildTaskCompleteAnimation(BuildContext context, {
  required Widget child, 
  required bool isCompleted,
}) {
  // Define the duration constant if it's not defined elsewhere
  const Duration mediumDuration = Duration(milliseconds: 300);
  
  return AnimatedContainer(
    duration: mediumDuration,
    transform: isCompleted
        ? (Matrix4.identity()..scale(1.05))
        : Matrix4.identity(),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: isCompleted
          ? [
              BoxShadow(
                color: AppColors.successGreen.withOpacity(0.6), // Using successGreen instead of completedTaskGlow
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : [],
    ),
    child: child,
  );
}

  /// XP bar fill animation
  static Widget buildXpBarAnimation(
    BuildContext context, {
    required double width,
    required double progress,
    required double height,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: mediumDuration,
      curve: Curves.easeOut,
      builder: (context, animatedProgress, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: Colors.grey[800],
          ),
          child: Stack(
            children: [
              // Progress fill
              Container(
                width: width * animatedProgress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.xpBarStart,
                      AppColors.xpBarEnd,
                    ],
                  ),
                ),
              ),
              
              // Shine effect
              if (animatedProgress > 0.1)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  left: width * animatedProgress - 20,
                  top: 0,
                  bottom: 0,
                  width: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Stat point increase animation
  static Widget buildStatPointAnimation(
    BuildContext context, {
    required int oldValue,
    required int newValue,
    required Widget Function(BuildContext, int) builder,
  }) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: oldValue, end: newValue),
      duration: mediumDuration,
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        return builder(context, value);
      },
    );
  }

  /// Streak counter animation
  static Widget buildStreakCounterAnimation(
    BuildContext context, {
    required int value,
    required Widget Function(BuildContext, int) builder,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: shortDuration,
      curve: bounceCurve,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: builder(context, value),
        );
      },
    );
  }

  /// Black heart pulse animation
  static Widget buildBlackHeartAnimation(BuildContext context, {required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.9, end: 1.1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Helper function to get color based on class name
  static Color getClassColor(String className) {
    switch (className.toUpperCase()) {
      case 'E':
        return AppColors.eClassColor;
      case 'D':
        return AppColors.dClassColor;
      case 'C':
        return AppColors.cClassColor;
      case 'B':
        return AppColors.bClassColor;
      case 'A':
        return AppColors.aClassColor;
      case 'S':
        return AppColors.sClassColor;
      case 'SS':
        return AppColors.ssClassColor;
      default:
        return AppColors.eClassColor;
    }
  }
  
  /// Quest notification animation
  static Widget buildQuestNotificationAnimation(BuildContext context, {required Widget child, required bool isActive}) {
    return AnimatedContainer(
      duration: mediumDuration,
      transform: isActive
          ? (Matrix4.identity()..translate(0.0, 0.0, 0.0))
          : (Matrix4.identity()..translate(0.0, -100.0, 0.0)),
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.0,
        duration: mediumDuration,
        child: child,
      ),
    );
  }
  
  /// Penalty task warning animation 
  static Widget buildPenaltyWarningAnimation(BuildContext context, {required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 2000),
      curve: Curves.elasticOut,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3 * value),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}