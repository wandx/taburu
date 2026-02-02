import 'package:taburu/src/taburu_table.dart';

abstract class TaburuContract {
  Future<List<TaburuTable>> fetchAll();

  Future<List<TaburuTable>> fetch(String roomName);

  Future<TaburuTable> add(TaburuTable table);

  Future<TaburuTable> update(TaburuTable table);

  Future<TaburuTable> delete(TaburuTable table);
}
