import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
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
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider(
      create: (_) => getIt<PreferenceBloc>()..add(FetchPreference(userId)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: theme.colorScheme.onSurface.withOpacity(0.1),
          toolbarHeight:
              isTablet ? 40 : 30, // Same height as LikesPage and SwipeScreen
          leading: Padding(
            padding: const EdgeInsets.only(left: ThemeConstant.smallPadding),
            child: Image.asset(
              'assets/icons/plain_logo.png', // Leftmost logo in AppBar
              height: isTablet ? 30 : 20,
              width: isTablet ? 30 : 20,
              fit: BoxFit.contain,
            ),
          ),
          leadingWidth: isTablet ? 40 : 30,
          title: Center(
            child: Image.asset(
              'assets/icons/text_logo.png', // Centered logo
              height: isTablet ? 30 : 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: customTheme.scaffoldGradient,
          ),
          padding: EdgeInsets.only(
            top: ThemeConstant.mediumPadding, // Space for AppBar
            left: isTablet
                ? ThemeConstant.largePadding
                : ThemeConstant.mediumPadding,
            right: isTablet
                ? ThemeConstant.largePadding
                : ThemeConstant.mediumPadding,
            bottom: isTablet
                ? ThemeConstant.largePadding
                : ThemeConstant.mediumPadding,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ThemeConstant.mediumBorderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(ThemeConstant.mediumPadding),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/pink_logo.jpg',
                    height: isTablet ? 200 : 150,
                    width: isTablet ? 200 : 150,
                  ),
                  SizedBox(height: ThemeConstant.mediumPadding),
                  Expanded(child: PreferenceContent()),
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
    final theme = Theme.of(context);

    return BlocBuilder<PreferenceBloc, PreferenceState>(
      builder: (context, state) {
        if (state is PreferenceLoading) {
          return Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary));
        } else if (state is PreferenceLoaded) {
          return FilterList(preference: state.preference);
        } else if (state is PreferenceError) {
          return Center(
              child: Text('Error: ${state.message}',
                  style: theme.textTheme.bodyLarge));
        }
        return Center(
            child: Text('Loading preferences...',
                style: theme.textTheme.bodyLarge));
      },
    );
  }
}

class FilterList extends StatelessWidget {
  final PreferenceEntity preference;

  const FilterList({super.key, required this.preference});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          padding: EdgeInsets.symmetric(vertical: ThemeConstant.smallPadding),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ThemeConstant.mediumBorderRadius),
            ),
            elevation: 2, // Added elevation for visual distinction
            child: ListTile(
              leading: Icon(icon, color: theme.colorScheme.primary),
              title: Text(label,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value ?? 'Add',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  SizedBox(width: ThemeConstant.smallPadding),
                  Icon(Icons.chevron_right, color: theme.colorScheme.primary),
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
        return ['Male', 'Female', 'Other', 'Any'];
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
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final question = _getFieldQuestion(widget.title);
    final options = _getFieldOptions(widget.keyField);
    final isAgeField = widget.keyField.toLowerCase().contains('age');
    final sliderMin =
        widget.keyField == 'maxAge' ? (widget.preference.minAge ?? 16) : 16;
    final sliderMax = 60;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ThemeConstant.mediumBorderRadius)),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstant.mediumBorderRadius)),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(ThemeConstant.mediumPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question,
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ThemeConstant.mediumPadding),
                  Container(
                    height: isTablet ? 120 : 100,
                    decoration: BoxDecoration(
                      gradient: customTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(
                          ThemeConstant.mediumBorderRadius),
                    ),
                    child: Center(
                      child: Icon(
                        _getIcon(widget.keyField),
                        size: isTablet ? 60 : 50,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeConstant.mediumPadding),
                  if (isAgeField)
                    Column(
                      children: [
                        Slider(
                          value: double.parse(selectedValue),
                          min: sliderMin.toDouble(),
                          max: sliderMax.toDouble(),
                          divisions: (sliderMax - sliderMin).toInt(),
                          label: selectedValue,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) => setState(
                              () => selectedValue = value.round().toString()),
                        ),
                        Text(
                          '$selectedValue years',
                          style: theme.textTheme.bodyLarge,
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
                                  style: theme.textTheme.bodyLarge),
                              value: option,
                              groupValue: selectedValue,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (value) =>
                                  setState(() => selectedValue = value!),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  SizedBox(height: ThemeConstant.mediumPadding),
                  Container(
                    decoration: BoxDecoration(
                      gradient: customTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(
                          ThemeConstant.largeBorderRadius),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave(selectedValue);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Confirm',
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: ThemeConstant.smallPadding,
              right: ThemeConstant.smallPadding,
              child: IconButton(
                icon: Icon(Icons.close, color: ThemeConstant.errorColor),
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
