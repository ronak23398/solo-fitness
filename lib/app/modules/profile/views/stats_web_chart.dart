import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'dart:math' show pi, min, cos, sin;
import 'package:flutter/animation.dart';

class AdaptiveStatsWebChart extends StatefulWidget {
  final UserModel user;
  final double size;

  const AdaptiveStatsWebChart({
    super.key,
    required this.user,
    this.size = 280.0,
  });

  @override
  State<AdaptiveStatsWebChart> createState() => _AdaptiveStatsWebChartState();
}

class _AdaptiveStatsWebChartState extends State<AdaptiveStatsWebChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _glowAnimation;
  
  double _maxStat = 50.0;
  double _previousMaxStat = 50.0;
  bool _showBreakthroughAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutQuart),
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInQuart),
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Determine the appropriate max stat based on user's stats
    _calculateMaxStat();
  }

  void _calculateMaxStat() {
    final stats = [
      widget.user.strength,
      widget.user.endurance,
      widget.user.agility,
      widget.user.intelligence,
      widget.user.discipline,
    ];

    final highestStat = stats.reduce((a, b) => a > b ? a : b).toDouble();
    _previousMaxStat = _maxStat;

    if (highestStat <= 25) {
      _maxStat = 25.0;
    } else if (highestStat <= 50) {
      _maxStat = 50.0;
    } else if (highestStat <= 100) {
      _maxStat = 100.0;
    } else if (highestStat <= 200) {
      _maxStat = 200.0;
    } else if (highestStat <= 300) {
      _maxStat = 300.0;
    } else {
      _maxStat = 500.0;
    }

    _showBreakthroughAnimation = _maxStat > _previousMaxStat;
    
    if (_showBreakthroughAnimation) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(AdaptiveStatsWebChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if stats have changed and recalculate max stat
    if (oldWidget.user.strength != widget.user.strength ||
        oldWidget.user.endurance != widget.user.endurance ||
        oldWidget.user.agility != widget.user.agility ||
        oldWidget.user.intelligence != widget.user.intelligence ||
        oldWidget.user.discipline != widget.user.discipline) {
      _calculateMaxStat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text('HUNTER STATS', style: AppTextStyles.subtitleBlack),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: StatsWebPainter(
                  strength: widget.user.strength / _maxStat,
                  endurance: widget.user.endurance / _maxStat,
                  agility: widget.user.agility / _maxStat,
                  intelligence: widget.user.intelligence / _maxStat,
                  discipline: widget.user.discipline / _maxStat,
                ),
              ),
            ),
            if (_showBreakthroughAnimation)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonBlue.withOpacity(_glowAnimation.value * 0.5),
                              spreadRadius: 20 * _glowAnimation.value,
                              blurRadius: 30 * _glowAnimation.value,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'BREAKTHROUGH',
                            style: TextStyle(
                              color: Colors.white.withOpacity(_opacityAnimation.value),
                              fontSize: 28 * _scaleAnimation.value,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: AppColors.neonBlue.withOpacity(_glowAnimation.value),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
       
      ],
    );
  }

 

    }

class StatsWebPainter extends CustomPainter {
  final double strength;
  final double endurance;
  final double agility;
  final double intelligence;
  final double discipline;

  StatsWebPainter({
    required this.strength,
    required this.endurance,
    required this.agility,
    required this.intelligence,
    required this.discipline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;
    
    _drawBackground(canvas, center, radius);
    _drawWebStats(canvas, center, radius);
    _drawLabels(canvas, center, radius);
  }

  void _drawBackground(Canvas canvas, Offset center, double radius) {
    // Draw background web (5 levels)
    final webPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (int i = 1; i <= 5; i++) {
      final path = Path();
      final webRadius = radius * i / 5;
      
      for (int j = 0; j < 5; j++) {
        final angle = j * 2 * pi / 5 - pi / 2;
        final point = Offset(
          center.dx + cos(angle) * webRadius,
          center.dy + sin(angle) * webRadius,
        );
        
        if (j == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      
      path.close();
      canvas.drawPath(path, webPaint);
    }
    
    // Draw lines from center to each point
    for (int i = 0; i < 5; i++) {
      final linePaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
        
      final angle = i * 2 * pi / 5 - pi / 2;
      final point = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      
      canvas.drawLine(center, point, linePaint);
    }
  }

  void _drawWebStats(Canvas canvas, Offset center, double radius) {
    final statValues = [strength, intelligence, discipline, endurance, agility];
    final colors = [
      AppColors.strengthColor,
      AppColors.intelligenceColor,
      AppColors.disciplineColor,
      AppColors.enduranceColor,
      AppColors.agilityColor,
    ];
    
    final path = Path();
    
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      final value = statValues[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + cos(angle) * radius * value,
        center.dy + sin(angle) * radius * value,
      );
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    
    path.close();
    
    // Create gradient for the filled area
    final Shader gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.withOpacity(0.7),
        Colors.purple.withOpacity(0.5),
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(
      center: center,
      radius: radius,
    ));
    
    // Draw filled area
    final fillPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;
      
    canvas.drawPath(path, fillPaint);
    
    // Draw glowing outline
    final outlinePaint = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      
    canvas.drawPath(path, outlinePaint);
    
    // Draw solid outline
    final solidOutline = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    canvas.drawPath(path, solidOutline);
    
    // Draw points at each stat position
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      final value = statValues[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + cos(angle) * radius * value,
        center.dy + sin(angle) * radius * value,
      );
      
      // Draw glow
      final glowPaint = Paint()
        ..color = colors[i].withOpacity(0.5)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
        
      canvas.drawCircle(point, 6.0, glowPaint);
      
      // Draw main point
      final pointPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(point, 5.0, pointPaint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
        
      canvas.drawCircle(point, 5.0, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final labels = ['Strength', 'Intelligence', 'Discipline', 'Endurance', 'Agility'];
    
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      
      // Position labels slightly beyond the chart
      final labelRadius = radius * 1.15;
      final point = Offset(
        center.dx + cos(angle) * labelRadius,
        center.dy + sin(angle) * labelRadius,
      );
      
      final textSpan = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      
      textPainter.layout();
      
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}