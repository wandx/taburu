import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taburu/src/taburu_controller.dart';
import 'package:taburu/src/taburu_table.dart';
import 'package:touchable/touchable.dart';

class TaburuPainter extends CustomPainter {
  TaburuPainter({
    required this.context,
    this.movable = false,
    this.showGrid = true,
    this.gridSize = 24,
    this.gridCrossSize = 24,
    this.onTableTapped,
    this.onTableLongPress,
    super.repaint,
  }) : controller = Provider.of<TaburuController>(context, listen: false)
         ..init(
           movable: movable,
           showGrid: showGrid,
           gridSize: gridSize,
           gridCrossSize: gridCrossSize,
         );

  final BuildContext context;
  final TaburuController controller;
  final bool movable;
  final bool showGrid;
  final int gridSize;
  final int gridCrossSize;
  final void Function(int)? onTableTapped;
  final void Function(int)? onTableLongPress;

  @override
  void paint(Canvas canvas, Size size) {
    final myCanvas = TouchyCanvas(context, canvas);

    final gridW = size.width / controller.gridSize;
    final gridH = size.width / controller.gridSize;

    if (controller.showGrid) {
      // draw vertical line
      for (var i = 0.0; i < size.width; i += gridW) {
        myCanvas.drawLine(
          Offset(i, 0),
          Offset(i, controller.gridCrossSize * gridH),
          Paint()..color = Colors.grey,
        );
      }

      // draw horizontal line
      for (var i = 0.0; i < (controller.gridCrossSize * gridH); i += gridH) {
        myCanvas.drawLine(
          Offset(0, i),
          Offset(size.width, i),
          Paint()..color = Colors.grey,
        );
      }
    }

    for (final table in controller.tables.indexed) {
      if (table.$2.shape == TableShape.rect) {
        myCanvas.drawRect(
          Rect.fromLTWH(
            table.$2.dx * gridW - 10,
            table.$2.dy * gridH - 10,
            table.$2.width * gridW + 20,
            table.$2.height * gridH + 20,
          ),
          Paint()
            ..color = Colors.red.withValues(
              alpha: controller.showTapArea ? 0.3 : 0,
            ),
          onPanUpdate: (detail) {
            if (!controller.movable) {
              return;
            }
            final dx = detail.localPosition.dx ~/ gridW * gridW;
            final dy = detail.localPosition.dy ~/ gridH * gridH;
            controller.moveTable(
              table.$1,
              dx / gridW,
              dy / gridH,
            );
          },
          onPanStart: (detail) {
            if (!controller.movable) {
              return;
            }
            controller.moveToTop(table.$1);
          },
        );
        final rect = Rect.fromLTWH(
          table.$2.dx * gridW,
          table.$2.dy * gridH,
          table.$2.width * gridW,
          table.$2.height * gridH,
        );

        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
        myCanvas.drawRRect(
          rrect,
          Paint()..color = table.$2.color.withValues(alpha: 0.8),
          onTapUp: (detail) {
            onTableTapped?.call(table.$1);
          },
        );

        final rectBorder = Rect.fromLTWH(
          table.$2.dx * gridW,
          table.$2.dy * gridH,
          table.$2.width * gridW,
          table.$2.height * gridH,
        );

        final rrectBorder = RRect.fromRectAndRadius(
          rectBorder,
          const Radius.circular(8),
        );

        myCanvas.drawRRect(
          rrectBorder,
          Paint()
            ..color = table.$2.borderColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5,
          onTapUp: (detail) {
            onTableTapped?.call(table.$1);
          },
          onLongPressEnd: (detail) {
            onTableLongPress?.call(table.$1);
          },
        );
      }

      if (table.$2.shape == TableShape.circular) {
        myCanvas.drawRect(
          Rect.fromLTWH(
            table.$2.dx * gridW - 10,
            table.$2.dy * gridH - 10,
            table.$2.width * gridW + 20,
            table.$2.height * gridH + 20,
          ),
          Paint()
            ..color = Colors.red.withValues(
              alpha: controller.showTapArea ? 0.3 : 0,
            ),
          onPanUpdate: (detail) {
            if (!controller.movable) {
              return;
            }
            final dx = detail.localPosition.dx ~/ gridW * gridW;
            final dy = detail.localPosition.dy ~/ gridH * gridH;
            controller.moveTable(
              table.$1,
              dx / gridW,
              dy / gridH,
            );
          },
          onPanStart: (detail) {
            if (!controller.movable) {
              return;
            }
            controller.moveToTop(table.$1);
          },
        );

        final rect = Rect.fromLTWH(
          table.$2.dx * gridW,
          table.$2.dy * gridH,
          table.$2.width * gridW,
          table.$2.height * gridH,
        );

        final rrect = RRect.fromRectAndRadius(
          rect,
          const Radius.circular(1000),
        );
        myCanvas.drawRRect(
          rrect,
          Paint()..color = table.$2.color.withValues(alpha: 0.8),
          onTapUp: (detail) {
            onTableTapped?.call(table.$1);
          },
          onLongPressEnd: (detail) {
            onTableLongPress?.call(table.$1);
          },
        );
      }

      if (table.$2.showText) {
        final baseTextOffsetX = table.$2.dx * gridW;
        final baseTextOffsetY = table.$2.dy * gridH;

        final nameText = TextPainter(
          text: TextSpan(
            text: table.$2.name,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: table.$2.width * gridW);
        final offset = Offset(
          baseTextOffsetX - (nameText.width / 2) + (table.$2.width * gridW) / 2,
          baseTextOffsetY + (table.$2.height * gridH) / 2 - 12,
        );
        nameText.paint(canvas, offset);

        final capacityText = TextPainter(
          text: TextSpan(
            text: '🧍${table.$2.usage}/${table.$2.capacity}',
            style: const TextStyle(
              fontSize: 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: table.$2.width * gridW);

        final capacityOffset = Offset(
          baseTextOffsetX -
              (capacityText.width / 2) +
              (table.$2.width * gridW) / 2,
          baseTextOffsetY + (table.$2.height * gridH) / 2,
        );

        capacityText.paint(canvas, capacityOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
