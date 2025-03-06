import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';

import '../../../../app/constants/theme_constant.dart';
import '../view_model/login/login_bloc.dart';
import '../view_model/login/login_event.dart';
import 'register_with_email_view.dart';
import 'register_with_number.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: "ab");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        title: const Text('Sign In'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/icons/pink_logo.jpg',
                height: isTablet ? 200 : 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: ThemeConstant.largePadding),
              Text(
                "Sign in to continue",
                style: theme.textTheme.displayMedium,
              ),
              Text(
                "Please log in to continue",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: ThemeConstant.mediumPadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: _validateUsername,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.smallPadding),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: _validatePassword,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: customTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(
                            ThemeConstant.largeBorderRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final bloc = context.read<LoginBloc>();
                            if (!bloc.isClosed) {
                              bloc.add(LoginUserEvent(
                                context: context,
                                userName: _usernameController.text,
                                password: _passwordController.text,
                              ));
                            } else {
                              debugPrint('LoginBloc is closed, cannot login');
                            }
                          }
                        },
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ThemeConstant.mediumPadding),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstant.smallPadding),
                    child: Text(
                      "Or sign in with",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ThemeConstant.largePadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterWithEmailView()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ThemeConstant.smallPadding,
                          horizontal: ThemeConstant.mediumPadding,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(
                              ThemeConstant.largeBorderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: theme.colorScheme.primary,
                              size: isTablet
                                  ? ThemeConstant.mediumIconSize
                                  : ThemeConstant.smallIconSize,
                            ),
                            SizedBox(width: ThemeConstant.smallPadding),
                            Text(
                              "Email",
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ThemeConstant.mediumPadding),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterWithNumber()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ThemeConstant.smallPadding,
                          horizontal: ThemeConstant.mediumPadding,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(
                              ThemeConstant.largeBorderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: theme.colorScheme.primary,
                              size: isTablet
                                  ? ThemeConstant.mediumIconSize
                                  : ThemeConstant.smallIconSize,
                            ),
                            SizedBox(width: ThemeConstant.smallPadding),
                            Text(
                              "Phone",
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ThemeConstant.largePadding),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Trouble Signing In?',
                          style: theme.textTheme.displayMedium),
                      content: Text(
                        'Please contact support or try resetting your password.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'OK',
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Trouble signing in?',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
