// lib/features/preference/presentation/pages/preference_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';

import '../../../domain/entity/preference_entity.dart';
import '../../view_model/bloc/preference_bloc.dart';
import '../../view_model/bloc/preference_event.dart';
import '../../view_model/bloc/preference_state.dart';

class PreferencePage extends StatelessWidget {
  const PreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
    return BlocProvider(
      create: (_) => getIt<PreferenceBloc>()..add(FetchPreference(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filter Matches'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFCE4EC), Color(0xFFE1BEE7)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Pink Logo at the top
                  Image.asset(
                    'assets/icons/pink_logo.jpg',
                    height: 150, 
                    width: 150,
                  ),
                  const SizedBox(height: 16),
                  // Content inside the card
                  const Expanded(child: PreferenceContent()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PreferenceContent extends StatelessWidget {
  const PreferenceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenceBloc, PreferenceState>(
      builder: (context, state) {
        if (state is PreferenceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PreferenceLoaded) {
          return FilterList(preference: state.preference);
        } else if (state is PreferenceError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Loading preferences...'));
      },
    );
  }
}

class FilterList extends StatelessWidget {
  final PreferenceEntity preference;

  const FilterList({super.key, required this.preference});

  @override
  Widget build(BuildContext context) {
    final fields = [
      {
        'key': 'preferredGender',
        'label': 'Gender',
        'icon': Icons.person_outline
      },
      {'key': 'minAge', 'label': 'As young as', 'icon': Icons.child_care},
      {'key': 'maxAge', 'label': 'As old as', 'icon': Icons.elderly},
      {
        'key': 'relationType',
        'label': 'Looking for',
        'icon': Icons.favorite_border
      },
      {
        'key': 'preferredStarSign',
        'label': 'Star sign',
        'icon': Icons.star_border
      },
      {'key': 'preferredReligion', 'label': 'Religion', 'icon': Icons.book},
    ];

    return ListView.builder(
      itemCount: fields.length,
      itemBuilder: (context, index) {
        final field = fields[index];
        final key = field['key'] as String;
        final label = field['label'] as String;
        final icon = field['icon'] as IconData;
        final value = _getValue(preference, key);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(icon, color: Colors.pinkAccent),
              title: Text(label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value ?? 'Add',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.pinkAccent),
                ],
              ),
              onTap: () => _showEditDialog(context, key, label, value),
            ),
          ),
        );
      },
    );
  }

  String? _getValue(PreferenceEntity preference, String key) {
    switch (key) {
      case 'preferredGender':
        return preference.preferredGender;
      case 'minAge':
        return preference.minAge?.toString();
      case 'maxAge':
        return preference.maxAge?.toString();
      case 'relationType':
        return preference.relationType;
      case 'preferredStarSign':
        return preference.preferredStarSign;
      case 'preferredReligion':
        return preference.preferredReligion;
      default:
        return null;
    }
  }

  void _showEditDialog(
      BuildContext context, String key, String label, String? currentValue) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditPreferenceDialog(
        keyField: key,
        title: label,
        currentValue: currentValue,
        preference: preference,
        onSave: (newValue) {
          final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
          final updatedPreference =
              _updatePreference(preference, key, newValue);
          context
              .read<PreferenceBloc>()
              .add(UpdatePreference(userId, updatedPreference));
        },
      ),
    );
  }

  PreferenceEntity _updatePreference(
      PreferenceEntity preference, String key, String value) {
    return PreferenceEntity(
      userId: preference.userId,
      preferredGender:
          key == 'preferredGender' ? value : preference.preferredGender,
      minAge: key == 'minAge' ? int.tryParse(value) : preference.minAge,
      maxAge: key == 'maxAge' ? int.tryParse(value) : preference.maxAge,
      relationType: key == 'relationType' ? value : preference.relationType,
      preferredStarSign:
          key == 'preferredStarSign' ? value : preference.preferredStarSign,
      preferredReligion:
          key == 'preferredReligion' ? value : preference.preferredReligion,
    );
  }
}

class EditPreferenceDialog extends StatefulWidget {
  final String keyField;
  final String title;
  final String? currentValue;
  final PreferenceEntity preference;
  final Function(String) onSave;

  const EditPreferenceDialog({
    super.key,
    required this.keyField,
    required this.title,
    this.currentValue,
    required this.preference,
    required this.onSave,
  });

  @override
  State<EditPreferenceDialog> createState() => _EditPreferenceDialogState();
}

class _EditPreferenceDialogState extends State<EditPreferenceDialog> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentValue ?? _getDefaultValue(widget.keyField);
  }

  String _getDefaultValue(String key) {
    switch (key) {
      case 'minAge':
      case 'maxAge':
        return '16';
      default:
        return '';
    }
  }

  String _getFieldQuestion(String title) {
    switch (title.toLowerCase()) {
      case 'gender':
        return 'What gender are you looking for?';
      case 'as young as':
        return 'Select the minimum age:';
      case 'as old as':
        return 'Select the maximum age:';
      case 'looking for':
        return 'What kind of relationship are you looking for?';
      case 'star sign':
        return 'Select your preferred star sign:';
      case 'religion':
        return 'What religion do you prefer?';
      default:
        return 'Enter $title...';
    }
  }

  List<String> _getFieldOptions(String key) {
    switch (key.toLowerCase()) {
      case 'preferredgender':
        return ['Male', 'Female', 'Others', 'Any'];
      case 'relationtype':
        return [
          'Long term',
          'Casual',
          'Wanna get married',
          'Fun dates',
          'Just friendship',
          'Any'
        ];
      case 'preferredstarsign':
        return [
          'Aries',
          'Taurus',
          'Gemini',
          'Cancer',
          'Leo',
          'Virgo',
          'Libra',
          'Scorpio',
          'Sagittarius',
          'Capricorn',
          'Aquarius',
          'Pisces',
          'Any'
        ];
      case 'preferredreligion':
        return [
          'Hindu',
          'Buddhist',
          'Muslim',
          'Christian',
          'Atheist',
          'Omniset',
          'Any'
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _getFieldQuestion(widget.title);
    final options = _getFieldOptions(widget.keyField);
    final isAgeField = widget.keyField.toLowerCase().contains('age');
    final sliderMin =
        widget.keyField == 'maxAge' ? (widget.preference.minAge ?? 16) : 16;
    final sliderMax = 60;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.pink[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Icon(
                          _getIcon(widget.keyField),
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isAgeField)
                    Column(
                      children: [
                        Slider(
                          value: double.parse(selectedValue),
                          min: sliderMin.toDouble(),
                          max: sliderMax.toDouble(),
                          divisions: (sliderMax - sliderMin).toInt(),
                          label: selectedValue,
                          activeColor: Colors.pink[600],
                          onChanged: (value) => setState(
                              () => selectedValue = value.round().toString()),
                        ),
                        Text(
                          '$selectedValue years',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    )
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: options.map((option) {
                            return RadioListTile<String>(
                              title: Text(option,
                                  style: const TextStyle(color: Colors.black)),
                              value: option,
                              groupValue: selectedValue,
                              activeColor: Colors.pink[600],
                              onChanged: (value) =>
                                  setState(() => selectedValue = value!),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      widget.onSave(selectedValue);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String key) {
    switch (key.toLowerCase()) {
      case 'preferredgender':
        return Icons.person_outline;
      case 'minage':
        return Icons.child_care;
      case 'maxage':
        return Icons.elderly;
      case 'relationtype':
        return Icons.favorite_border;
      case 'preferredstarsign':
        return Icons.star_border;
      case 'preferredreligion':
        return Icons.book;
      default:
        return Icons.info;
    }
  }
}
