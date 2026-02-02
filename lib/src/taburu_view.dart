import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taburu/src/taburu_add_dialog.dart';
import 'package:taburu/src/taburu_controller.dart';
import 'package:taburu/src/taburu_painter.dart';
import 'package:taburu/src/taburu_table.dart';
import 'package:touchable/touchable.dart';

class TaburuView extends StatelessWidget {
  const TaburuView({required this.padding, super.key});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaburuController>(context, listen: false);
    final deviceW = MediaQuery.sizeOf(context).width;
    final gridH = deviceW / controller.gridSize;

    return ClipRRect(
      child: Container(
        width: MediaQuery.sizeOf(context).width - (padding * 2),
        padding: EdgeInsets.only(bottom: padding),
        height: controller.gridCrossSize * gridH,
        child: Consumer<TaburuController>(
          builder: (context, controller, child) => CanvasTouchDetector(
            gesturesToOverride: const [
              GestureType.onPanDown,
              GestureType.onPanUpdate,
              GestureType.onPanStart,
              GestureType.onTapUp,
              GestureType.onLongPressEnd,
            ],
            builder: (context) => CustomPaint(
              painter: TaburuPainter(
                context: context,
                movable: true,
                onTableTapped: (index) async {
                  final table = controller.tables[index];
                  final newTable = await showDialog<TaburuTable?>(
                    context: context,
                    builder: (_) => TaburuAddDialog(
                      table: table,
                      width: controller.gridSize,
                      height: controller.gridCrossSize,
                    ),
                  );
                  if (newTable != null) {
                    controller.updateTableOnIndex(index, newTable);
                  }
                },
                onTableLongPress: (index) {
                  controller.duplicateTable(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
