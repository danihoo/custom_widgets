import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dimensions.dart';

class DialogDatePicker extends StatelessWidget {
  final bool editable;
  final String label;
  final DateTime date;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime value) onChanged;

  DialogDatePicker({
    Key? key,
    this.editable = true,
    required this.label,
    DateTime? date,
    required this.onChanged,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : date = date ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(2020),
        lastDate = lastDate ?? DateTime(2199, 12, 31),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SizedBox(
        height: inputHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(label)),
              SizedBox(width: 12),
              _DateField(
                editable: editable,
                date: date,
                firstDate: firstDate,
                lastDate: lastDate,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final bool editable;
  final DateTime date;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime value) onChanged;

  const _DateField({
    Key? key,
    required this.editable,
    required this.date,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateString = _formatDate(date);
    return editable
        ? TextButton(
            onPressed: () => _onTap(context),
            child: Text(dateString),
          )
        : Text(dateString);
  }

  void _onTap(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onChanged(DateUtils.dateOnly(picked));
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }
}
