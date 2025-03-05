import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';

import '../../../../app/constants/theme_constant.dart';
import '../../../../app/di/di.dart';
import '../view_model/signup/register_bloc.dart';
import 'register_view.dart';

class UserConformationView extends StatefulWidget {
  final String emailOrPhone;
  final bool isEmail;

  const UserConformationView({
    required this.emailOrPhone,
    required this.isEmail,
    super.key,
  });

  @override
  State<UserConformationView> createState() => _UserConformationViewState();
}

class _UserConformationViewState extends State<UserConformationView> {
  List<String> verificationCode = ["", "", "", "", ""];
  List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(5, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void onChanged(String value, int index) {
    setState(() {
      verificationCode[index] = value;
      controllers[index].text = value;
    });

    if (value.isNotEmpty && index < 4) {
      focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final circleSize = isTablet ? 60.0 : 50.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: customTheme.scaffoldGradient,
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet
              ? ThemeConstant.largePadding
              : ThemeConstant.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 80 : 60),
              Text(
                'Enter verification code',
                style: theme.textTheme.displayMedium,
              ),
              SizedBox(height: ThemeConstant.smallPadding),
              Text(
                'Please enter the verification code we sent you.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: ThemeConstant.largePadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstant.smallPadding),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: verificationCode[index].isEmpty
                            ? theme.colorScheme.surface
                            : theme.colorScheme.primary,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          verificationCode[index],
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: verificationCode[index].isEmpty
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: ThemeConstant.mediumPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: circleSize,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      autofocus: index == 0,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) => onChanged(value, index),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "",
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      style: const TextStyle(fontSize: 1, height: 0.1),
                      cursorColor: Colors.transparent,
                    ),
                  );
                }),
              ),
              SizedBox(height: ThemeConstant.mediumPadding),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: customTheme.buttonGradient,
                  borderRadius:
                      BorderRadius.circular(ThemeConstant.largeBorderRadius),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print('Verification code: ${verificationCode.join()}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: getIt<RegisterBloc>(),
                          child: RegisterView(
                            emailOrPhone: widget.emailOrPhone,
                            isEmail: widget.isEmail,
                          ),
                        ),
                      ),
                    );
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
      ),
    );
  }
}
