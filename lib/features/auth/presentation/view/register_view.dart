import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view/login_view.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:softwarica_student_management_bloc/features/splash/presentation/view_model/splash_cubit.dart';

class RegisterView extends StatefulWidget {
  final String emailOrPhone;
  final bool isEmail;

  const RegisterView({
    required this.emailOrPhone,
    required this.isEmail,
    super.key,
  });

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _starSignController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  DateTime? _birthDate;
  String? _gender; // No default gender value
  final String _starSign = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController.text = widget.emailOrPhone;
  }

  String _getStarSign(DateTime birthDate) {
    final month = birthDate.month;
    final day = birthDate.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    }
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailOrPhoneController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: widget.isEmail ? "Email" : "Phone Number",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your ${widget.isEmail ? 'email' : 'phone number'}.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your full name.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Gender:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE03368),
                        ),
                      ),
                      Radio<String>(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Female'),
                      Radio<String>(
                        value: 'Other',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Other'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(
                  text: _birthDate == null
                      ? ''
                      : DateFormat('yyyy/MM/dd').format(_birthDate!),
                ),
                decoration: const InputDecoration(
                  labelText: "Birthdate",
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDate = pickedDate;
                      _starSignController.text = _getStarSign(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select your birthdate.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false,
                controller: _starSignController,
                decoration: const InputDecoration(
                  labelText: "Star Sign",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                maxLines: 3, // Increased text area
                decoration: const InputDecoration(
                  labelText: "Bio (Optional)",
                ),
              ),
              const SizedBox(height: 24), // Added spacing
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Login credentials",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(text: widget.emailOrPhone),
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password.";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint(_confirmPasswordController.text);

                      if (_formKey.currentState!.validate()) {
                        final registerEvent = widget.isEmail
                            ? RegisterUser(
                                context: context,
                                email: widget.emailOrPhone,
                                name: _nameController.text,
                                gender: _gender ?? '',
                                birthDate: _birthDate!,
                                starSign: _starSignController.text,
                                bio: _bioController.text,
                                userName: widget.emailOrPhone,
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              )
                            : RegisterUser(
                                context: context,
                                phoneNumber: widget.emailOrPhone,
                                name: _nameController.text,
                                gender: _gender ?? '',
                                birthDate: _birthDate!,
                                starSign: _starSignController.text,
                                bio: _bioController.text,
                                userName: widget.emailOrPhone,
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              );
                        context.read<RegisterBloc>().add(registerEvent);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: getIt<SplashCubit>(),
                              child: LoginView(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFE03368),
                    ),
                    child: const Text('Sign Up'),
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
