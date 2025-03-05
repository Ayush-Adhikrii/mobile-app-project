import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';

import '../../../../app/constants/theme_constant.dart';
import '../../../../app/di/di.dart';
import '../../../splash/presentation/view_model/splash_cubit.dart';
import 'login_view.dart';
import 'user_conformation_view.dart';

class RegisterWithEmailView extends StatefulWidget {
  const RegisterWithEmailView({super.key});

  @override
  State<RegisterWithEmailView> createState() => _RegisterWithEmailViewState();
}

class _RegisterWithEmailViewState extends State<RegisterWithEmailView> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: getIt<SplashCubit>(),
                  child: LoginView(),
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: customTheme.scaffoldGradient,
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? ThemeConstant.largePadding : ThemeConstant.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 80 : 60),
              Text(
                'Enter your email address',
                style: theme.textTheme.displayMedium,
              ),
              SizedBox(height: ThemeConstant.smallPadding),
              Text(
                'Please enter your email address to sign up',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: ThemeConstant.mediumPadding),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ThemeConstant.mediumPadding),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Email Address',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      contentPadding: EdgeInsets.symmetric(vertical: ThemeConstant.mediumPadding),
                    ),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
              SizedBox(height: ThemeConstant.largePadding),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: customTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserConformationView(
                          emailOrPhone: email,
                          isEmail: true,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Continue',
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