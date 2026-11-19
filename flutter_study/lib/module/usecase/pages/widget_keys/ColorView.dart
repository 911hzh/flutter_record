import 'package:flutter/material.dart';

class ColorStateFullView extends StatefulWidget {
  const ColorStateFullView({super.key, required this.id});

  final int id;

  @override
  State<ColorStateFullView> createState() => _ColorStateFullViewState();
}

class _ColorStateFullViewState extends State<ColorStateFullView> {
  static const _colors = [Colors.red, Colors.blue, Colors.teal, Colors.purple];
  late final Color _color;
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    _color = _colors[widget.id % _colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final label = switch (widget.id) {
      0 => 'A',
      1 => 'B',
      _ => '#${widget.id + 1}',
    };

    return OutlinedButton.icon(
      onPressed: () => setState(() => _taps++),
      icon: Icon(Icons.circle, color: _color),
      label: Text('$label · $_taps 次'),
    );
  }
}
