import 'package:flutter/material.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';

class EditFieldModal extends StatefulWidget {
  final String field;
  final String title;
  final IconData icon;
  final String currentValue;
  final Function(String, String) onSave;

  const EditFieldModal({
    super.key,
    required this.field,
    required this.title,
    required this.icon,
    required this.currentValue,
    required this.onSave,
  });

  @override
  _EditFieldModalState createState() => _EditFieldModalState();
}

class _EditFieldModalState extends State<EditFieldModal> {
  late TextEditingController _controller;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
    _selectedOption =
        widget.currentValue.isNotEmpty ? widget.currentValue : null;
  }

  @override
  Widget build(BuildContext context) {
    final options = _getFieldOptions(widget.title);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Icon(widget.icon, size: 50, color: ThemeConstant.primaryColor),
          const SizedBox(height: 20),
          Text(
            _getFieldQuestion(widget.title),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          if (options.isNotEmpty)
            Column(
              children: options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) => setState(() => _selectedOption = value),
                  activeColor: ThemeConstant.primaryColor,
                );
              }).toList(),
            )
          else
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter ${widget.title.toLowerCase()}...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              widget.onSave(
                  widget.field,
                  options.isNotEmpty
                      ? _selectedOption ?? ''
                      : _controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeConstant.primaryColor,
                      ThemeConstant.primaryColor.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Extra padding for keyboard
        ],
      ),
    );
  }

  String _getFieldQuestion(String title) {
    switch (title.toLowerCase()) {
      case 'profession':
        return 'What do you do for a living?';
      case 'height':
        return 'How tall are you?';
      case 'education':
        return 'What is your highest level of education?';
      case 'exercise':
        return 'How often do you exercise?';
      case 'drinks':
        return 'Do you drink alcohol? If so, how often?';
      case 'smoke':
        return 'Do you smoke?';
      case 'kids':
        return 'Do you have kids?';
      case 'religion':
        return 'What is your religion?';
      default:
        return 'Enter $title...';
    }
  }

  List<String> _getFieldOptions(String title) {
    switch (title.toLowerCase()) {
      case 'exercise':
        return ['Sometimes', 'Regularly', 'Never', 'Try to but I fail'];
      case 'drinks':
        return ['Sometimes', 'Social drinker', 'Never', 'I live by the glass'];
      case 'smoke':
        return [
          'Active smoker',
          'Only while drinking',
          'Never',
          "Can't stand the smell"
        ];
      case 'kids':
        return ['I already have', 'Want to have', "Don't want any"];
      case 'religion':
        return [
          'Hindu',
          'Muslim',
          'Christian',
          'Buddhist',
          'Atheist',
          'Omnist'
        ];
      default:
        return [];
    }
  }
}
