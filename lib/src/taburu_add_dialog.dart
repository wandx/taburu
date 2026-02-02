import 'package:flutter/material.dart';
import 'package:taburu/src/taburu_table.dart';

class TaburuAddDialog extends StatefulWidget {
  const TaburuAddDialog({
    required this.height,
    required this.width,
    super.key,
    this.table,
  });

  final TaburuTable? table;
  final int width;
  final int height;

  @override
  State<TaburuAddDialog> createState() => _TaburuAddDialogState();
}

class _TaburuAddDialogState extends State<TaburuAddDialog> {
  final _fk = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _width = TextEditingController();
  final _height = TextEditingController();
  final _capacity = TextEditingController();
  final _usage = TextEditingController();

  TableShape? _shape;
  bool _showText = true;

  @override
  void initState() {
    super.initState();
    if (widget.table != null) {
      _name.text = widget.table!.name;
      _width.text = widget.table!.width.toStringAsPrecision(1);
      _height.text = widget.table!.height.toStringAsPrecision(1);
      _capacity.text = widget.table!.capacity.toString();
      _usage.text = widget.table!.usage.toString();
      _shape = widget.table!.shape;
      _showText = widget.table!.showText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _fk,
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              Builder(
                builder: (context) {
                  if (widget.table != null) {
                    return const Text(
                      'Edit Table',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const Text(
                    'Add Table',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const Divider(),
              Column(
                mainAxisSize: .min,
                spacing: 10,
                children: [
                  DropdownButtonFormField(
                    items: TableShape.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _shape = v;
                      });
                    },
                    validator: (v) {
                      if (v == null) {
                        return 'Please select a shape';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Shape',
                    ),
                    initialValue: _shape,
                  ),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _width,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Width',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a width';
                            }

                            final width = double.tryParse(v);
                            if (width == null) {
                              return 'Please enter a valid width';
                            }

                            if (width < 1) {
                              return 'Width cannot be 0 or less';
                            }

                            if (width > widget.width) {
                              return 'Width cannot be greater '
                                  'than ${widget.width}';
                            }

                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _height,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a height';
                            }

                            final height = double.tryParse(v);
                            if (height == null) {
                              return 'Please enter a valid height';
                            }

                            if (height < 1) {
                              return 'Height cannot be 0 or less';
                            }

                            if (height > widget.height) {
                              return 'Height cannot be greater '
                                  'than ${widget.height}';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _capacity,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Capacity',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a capaacity';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _usage,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Usage',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a usage';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  CheckboxListTile.adaptive(
                    value: _showText,
                    onChanged: (v) {
                      setState(() {
                        _showText = v ?? false;
                      });
                    },
                    title: const Text('Show Text'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_fk.currentState!.validate()) {
                    return;
                  }
                  final table = TaburuTable(
                    name: _name.text,
                    width: double.tryParse(_width.text) ?? 2,
                    height: double.tryParse(_height.text) ?? 2,
                    dx: widget.table?.dx ?? 1,
                    dy: widget.table?.dy ?? 1,
                    shape: _shape ?? TableShape.rect,
                    capacity: int.tryParse(_capacity.text) ?? 1,
                    usage: int.tryParse(_usage.text) ?? 0,
                    showText: _showText,
                    roomName: 'Ase'
                  );

                  Navigator.of(context).pop(table);
                },
                child: Builder(
                  builder: (context) {
                    if (widget.table != null) {
                      return const Text('Save');
                    }
                    return const Text('Add');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
