import 'package:flutter/material.dart';
import 'package:taburu/src/taburu_table.dart';

class TaburuController extends ChangeNotifier {
  final tables = <TaburuTable>[];
  bool showGrid = true;
  bool showTapArea = false;
  int gridSize = 24;
  int gridCrossSize = 24;
  bool movable = false;

  void init({
    bool showGrid = false,
    bool showTapArea = false,
    int gridSize = 24,
    int gridCrossSize = 24,
    bool movable = false,
  }) {
    this.showGrid = showGrid;
    this.showTapArea = showTapArea;
    this.gridSize = gridSize;
    this.gridCrossSize = gridCrossSize;
    this.movable = movable;
  }

  void addAll(List<TaburuTable> tables) {
    this.tables.addAll(tables);
    notifyListeners();
  }

  void toggleMovable() {
    movable = !movable;
    notifyListeners();
  }

  void toggleGrid() {
    showGrid = !showGrid;
    notifyListeners();
  }

  void toggleTapArea() {
    showTapArea = !showTapArea;
    notifyListeners();
  }

  void updateGridSize(int size, {int crossSize = 24}) {
    gridSize = size;
    gridCrossSize = crossSize;
    notifyListeners();
  }

  void addTable(TaburuTable table) {
    tables.add(table);
    notifyListeners();
  }

  void duplicateTable(int index) {
    final currentTable = tables[index];
    addTable(
      currentTable.copyWith(
        name: '${currentTable.name} (copy)',
        dx: currentTable.dx + 1,
        dy: currentTable.dy + 1,
      ),
    );
  }

  void updateTableOnIndex(int index, TaburuTable table) {
    tables[index] = table;
    notifyListeners();
  }

  void removeTableOfIndex(int index) {
    tables.removeAt(index);
    notifyListeners();
  }

  void moveTable(int index, double dx, double dy) {
    final currentTable = tables[index];
    tables[index] = currentTable.copyWith(
      dx: dx,
      dy: dy,
    );
    notifyListeners();
  }

  void moveToTop(int index) {
    final currentTable = tables[index];
    // swap index with last index
    tables[index] = tables[tables.length - 1];
    tables[tables.length - 1] = currentTable;
    notifyListeners();
  }
}
