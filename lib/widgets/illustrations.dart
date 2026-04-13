import 'package:flutter/material.dart';
import 'dart:math';

/// Custom painted water cycle diagram
class WaterCycleDiagram extends StatelessWidget {
  const WaterCycleDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade50,
            Colors.brown.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LE CYCLE DE L\'EAU',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Diagram
          SizedBox(
            height: 280,
            child: CustomPaint(
              painter: _WaterCyclePainter(),
              size: const Size(double.infinity, 280),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterCyclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Sun (top right)
    paint.color = Colors.orange.shade300;
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12), 25, paint);
    // Sun rays
    linePaint.color = Colors.orange.shade300;
    linePaint.strokeWidth = 2;
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      canvas.drawLine(
        Offset(
          size.width * 0.85 + 30 * cos(angle),
          size.height * 0.12 + 30 * sin(angle),
        ),
        Offset(
          size.width * 0.85 + 40 * cos(angle),
          size.height * 0.12 + 40 * sin(angle),
        ),
        linePaint,
      );
    }

    // Clouds (top)
    _drawCloud(
      canvas,
      Offset(size.width * 0.4, size.height * 0.15),
      Colors.white,
      1.0,
    );
    _drawCloud(
      canvas,
      Offset(size.width * 0.65, size.height * 0.1),
      Colors.grey.shade300,
      0.8,
    );

    // Mountains (left)
    final mountainPath = Path();
    mountainPath.moveTo(0, size.height);
    mountainPath.lineTo(size.width * 0.15, size.height * 0.35);
    mountainPath.lineTo(size.width * 0.3, size.height * 0.55);
    mountainPath.lineTo(size.width * 0.35, size.height);
    mountainPath.close();
    paint.color = Colors.brown.shade300;
    canvas.drawPath(mountainPath, paint);

    // Snow on mountain
    final snowPath = Path();
    snowPath.moveTo(size.width * 0.15, size.height * 0.35);
    snowPath.lineTo(size.width * 0.12, size.height * 0.42);
    snowPath.lineTo(size.width * 0.18, size.height * 0.42);
    snowPath.close();
    paint.color = Colors.white;
    canvas.drawPath(snowPath, paint);

    // Ground
    final groundPath = Path();
    groundPath.moveTo(0, size.height * 0.75);
    groundPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.7,
      size.width,
      size.height * 0.8,
    );
    groundPath.lineTo(size.width, size.height);
    groundPath.lineTo(0, size.height);
    groundPath.close();
    paint.color = Colors.green.shade400;
    canvas.drawPath(groundPath, paint);

    // Water (right bottom)
    final waterPath = Path();
    waterPath.moveTo(size.width * 0.55, size.height * 0.85);
    waterPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.85,
    );
    waterPath.lineTo(size.width, size.height);
    waterPath.lineTo(size.width * 0.55, size.height);
    waterPath.close();
    paint.color = Colors.blue.shade400;
    canvas.drawPath(waterPath, paint);

    // Ocean label
    _drawLabel(
      canvas,
      Offset(size.width * 0.78, size.height * 0.92),
      'OCÉAN',
      Colors.blue.shade700,
    );

    // Arrows for the cycle
    linePaint.color = Colors.blue.shade700;
    linePaint.strokeWidth = 3;

    // Evaporation (up from ocean)
    _drawArrowUp(
      canvas,
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.6, size.height * 0.3),
      Colors.blue.shade700,
    );
    _drawLabel(
      canvas,
      Offset(size.width * 0.72, size.height * 0.55),
      'ÉVAPORATION',
      Colors.blue.shade800,
    );

    // Condensation (cloud)
    _drawLabel(
      canvas,
      Offset(size.width * 0.35, size.height * 0.25),
      'CONDENSATION',
      Colors.grey.shade700,
    );

    // Precipitation (down from cloud to mountain)
    _drawArrowDown(
      canvas,
      Offset(size.width * 0.45, size.height * 0.25),
      Offset(size.width * 0.25, size.height * 0.5),
      Colors.blue.shade700,
    );
    _drawLabel(
      canvas,
      Offset(size.width * 0.2, size.height * 0.35),
      'PRÉCIPITATION',
      Colors.blue.shade800,
    );

    // Rain drops
    paint.color = Colors.blue.shade300;
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.35 + i * 12, size.height * 0.3 + i * 8),
        2,
        paint,
      );
    }

    // Infiltration (ground to underground)
    _drawArrowDown(
      canvas,
      Offset(size.width * 0.3, size.height * 0.65),
      Offset(size.width * 0.3, size.height * 0.85),
      Colors.brown.shade700,
    );
    _drawLabel(
      canvas,
      Offset(size.width * 0.05, size.height * 0.75),
      'INFILTRATION',
      Colors.brown.shade800,
    );

    // Runoff (mountain to ocean)
    _drawArrowRight(
      canvas,
      Offset(size.width * 0.35, size.height * 0.78),
      Offset(size.width * 0.55, size.height * 0.82),
      Colors.blue.shade700,
    );
    _drawLabel(
      canvas,
      Offset(size.width * 0.42, size.height * 0.72),
      'RUISSELLEMENT',
      Colors.blue.shade800,
    );

    // Transpiration (from trees)
    _drawArrowUp(
      canvas,
      Offset(size.width * 0.5, size.height * 0.75),
      Offset(size.width * 0.55, size.height * 0.45),
      Colors.green.shade700,
    );
    _drawLabel(
      canvas,
      Offset(size.width * 0.52, size.height * 0.6),
      'TRANSPIRATION',
      Colors.green.shade800,
    );
  }

  void _drawCloud(Canvas canvas, Offset center, Color color, double scale) {
    final paint = Paint()..color = color;
    canvas.drawCircle(center, 20 * scale, paint);
    canvas.drawCircle(
      center.translate(-15 * scale, 5 * scale),
      15 * scale,
      paint,
    );
    canvas.drawCircle(
      center.translate(15 * scale, 5 * scale),
      15 * scale,
      paint,
    );
    canvas.drawCircle(
      center.translate(-8 * scale, -8 * scale),
      12 * scale,
      paint,
    );
    canvas.drawCircle(
      center.translate(8 * scale, -8 * scale),
      12 * scale,
      paint,
    );
  }

  void _drawArrowUp(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Line
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(start.dx, (start.dy + end.dy) / 2, end.dx, end.dy);
    canvas.drawPath(path, paint);

    // Arrow head
    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(end.dx - 8, end.dy + 12);
    arrowPath.lineTo(end.dx + 8, end.dy + 12);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  void _drawArrowDown(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(start.dx, (start.dy + end.dy) / 2, end.dx, end.dy);
    canvas.drawPath(path, paint);

    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(end.dx - 8, end.dy - 12);
    arrowPath.lineTo(end.dx + 8, end.dy - 12);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  void _drawArrowRight(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawLine(start, end, paint);

    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(end.dx - 12, end.dy - 8);
    arrowPath.lineTo(end.dx - 12, end.dy + 8);
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowPaint);
  }

  void _drawLabel(Canvas canvas, Offset pos, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Phase change diagram
class PhaseChangeDiagram extends StatelessWidget {
  const PhaseChangeDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'CHANGEMENT DE PHASE DE L\'EAU',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _phaseBox(
                icon: Icons.ac_unit,
                label: 'GLACE',
                subtitle: 'Solide (< 0°C)',
                color: Colors.lightBlue.shade300,
              ),
              _phaseArrow(true),
              _phaseBox(
                icon: Icons.water_drop,
                label: 'EAU',
                subtitle: 'Liquide (0-100°C)',
                color: Colors.blue.shade400,
              ),
              _phaseArrow(true),
              _phaseBox(
                icon: Icons.cloud,
                label: 'VAPEUR',
                subtitle: 'Gaz (> 100°C)',
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Process labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _processLabel('Fusion', 80),
              const SizedBox(width: 60),
              _processLabel('Vaporisation', 100),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _processLabel('Solidification', 80),
              const SizedBox(width: 60),
              _processLabel('Condensation', 100),
            ],
          ),
          const SizedBox(height: 12),
          // Temperature scale
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('❄️ 0°C', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlue,
                          Colors.blue,
                          Colors.grey.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Text('100°C 💨', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phaseBox({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, size: 36, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _phaseArrow(bool forward) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              forward ? Icons.arrow_forward : Icons.arrow_back,
              size: 24,
              color: Colors.blue.shade700,
            ),
            Icon(
              forward ? Icons.arrow_back : Icons.arrow_forward,
              size: 18,
              color: Colors.orange.shade700,
            ),
          ],
        ),
      ],
    );
  }

  Widget _processLabel(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Water distribution table
class WaterDistributionTable extends StatelessWidget {
  const WaterDistributionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        'name': 'Océans et mers',
        'percent': 97.5,
        'color': Colors.blue.shade700,
      },
      {
        'name': 'Glaciers et calottes',
        'percent': 1.74,
        'color': Colors.lightBlue.shade300,
      },
      {
        'name': 'Eaux souterraines',
        'percent': 0.73,
        'color': Colors.blue.shade400,
      },
      {
        'name': 'Lacs et rivières',
        'percent': 0.007,
        'color': Colors.blue.shade200,
      },
      {'name': 'Atmosphère', 'percent': 0.001, 'color': Colors.grey.shade300},
      {'name': 'Biosphère', 'percent': 0.0001, 'color': Colors.green.shade300},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'RÉPARTITION DE L\'EAU SUR TERRE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text(
                  'Réservoir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Pourcentage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 60,
                child: Text(
                  '%',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 4),
          // Data rows
          ...data.map(
            (d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      d['name'] as String,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: (d['color'] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            (d['percent'] as double) /
                            100 *
                            5, // scaled for visibility
                        child: Container(
                          decoration: BoxDecoration(
                            color: d['color'] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${d['percent']}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: d['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // Summary
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('💧 Eau salée', style: TextStyle(fontSize: 11)),
                Text(
                  '97,5%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🚰 Eau douce', style: TextStyle(fontSize: 11)),
                Text(
                  '2,5%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
