import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/category_type.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/entities/tire_spec.dart';
import '../../../domain/entities/vehicle_make.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryType type;
  final dynamic existing;

  const CategoryDialog({super.key, required this.type, this.existing});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final name = TextEditingController();
  final logo = TextEditingController();

  final width = TextEditingController();
  final aspect = TextEditingController();
  final rim = TextEditingController();

  @override
  void initState() {
    super.initState();

    final e = widget.existing;

    if (e is Brand || e is VehicleMake) {
      name.text = e.name;
      logo.text = e.logoUrl ?? '';
    }

    if (e is TireSpec) {
      width.text = e.width.toString();
      aspect.text = e.aspectRatio.toString();
      rim.text = e.rimDiameter.toString();
    }
  }

  void _submit() {
    final bloc = context.read<CategoryBloc>();
    final existing = widget.existing;

    dynamic entity;

    if (widget.type == CategoryType.tireBrand) {
      final id = existing is Brand ? existing.id : '';

      entity = Brand(
        id: id,
        name: name.text,
        logoUrl: logo.text,
      );
    }

    if (widget.type == CategoryType.vehicleMake) {
      final id = existing is VehicleMake ? existing.id : '';

      entity = VehicleMake(
        id: id,
        name: name.text,
        logoUrl: logo.text,
      );
    }

    if (widget.type == CategoryType.tireSpec) {
      final id = existing is TireSpec ? existing.id : '';

      entity = TireSpec(
        id: id,
        width: int.parse(width.text),
        aspectRatio: int.parse(aspect.text),
        rimDiameter: int.parse(rim.text),
      );
    }

    // Decide create vs update
    if (existing == null) {
      bloc.add(
        CreateCategory(
          type: widget.type,
          category: entity,
        ),
      );
    } else {
      bloc.add(
        UpdateCategory(
          type: widget.type,
          category: entity,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.existing == null ? "Add Category" : "Edit Category";

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.type != CategoryType.tireSpec) ...[
            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: logo, decoration: const InputDecoration(labelText: "Logo URL")),
          ],
          if (widget.type == CategoryType.tireSpec) ...[
            TextField(controller: width, decoration: const InputDecoration(labelText: "Width")),
            TextField(controller: aspect, decoration: const InputDecoration(labelText: "Aspect Ratio")),
            TextField(controller: rim, decoration: const InputDecoration(labelText: "Rim Diameter")),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: _submit, child: const Text("Save")),
      ],
    );
  }
}