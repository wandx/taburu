import 'package:flutter/material.dart';

class TaburuTable {
  const TaburuTable({
    required this.name,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.roomName,
    this.capacity = 1,
    this.usage = 0,
    this.color = Colors.brown,
    this.borderColor = Colors.transparent,
    this.shape = TableShape.rect,
    this.showText = true,
  });

  final String name;
  final double dx;
  final double dy;
  final double width;
  final double height;
  final String roomName;
  final Color color;
  final int capacity;
  final int usage;
  final Color borderColor;
  final TableShape shape;
  final bool showText;

  factory TaburuTable.fromJson(Map<String, dynamic> json) {
    return TaburuTable(
      name: json['name'] as String,
      dx: json['dx'] as double,
      dy: json['dy'] as double,
      width: json['width'] as double,
      height: json['height'] as double,
      roomName: json['room_name'] as String,
      color: Color(json['color'] as int),
      capacity: json['capacity'] as int,
      usage: json['usage'] as int,
      borderColor: Color(json['border_color'] as int),
      shape: TableShape.values[json['shape'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'dx': dx,
      'dy': dy,
      'width': width,
      'height': height,
      'room_name': roomName,
      'color': color.value,
      'capacity': capacity,
      'usage': usage,
      'border_color': borderColor.value,
      'shape': shape.index,
      'show_text': showText,
    };
  }

  TaburuTable copyWith({
    String? name,
    double? dx,
    double? dy,
    double? width,
    double? height,
    String? roomName,
    Color? color,
    int? capacity,
    int? usage,
    Color? borderColor,
    TableShape? shape,
    bool? showText,
  }) {
    return TaburuTable(
      name: name ?? this.name,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      height: height ?? this.height,
      roomName: roomName ?? this.roomName,
      color: color ?? this.color,
      capacity: capacity ?? this.capacity,
      usage: usage ?? this.usage,
      borderColor: borderColor ?? this.borderColor,
      shape: shape ?? this.shape,
      showText: showText ?? this.showText,
    );
  }

  @override
  String toString() {
    return 'TaburuTable(name: $name, dx: $dx, dy: $dy, '
        'width: $width, height: $height, roomName: $roomName, color: $color, '
        'capacity: $capacity, usage: $usage, borderColor: $borderColor, '
        'shape: $shape, showText: $showText)';
  }
}

enum TableShape { rect, circular }
