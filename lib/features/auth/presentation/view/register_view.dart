import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';

import '../../../../app/di/di.dart';
import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../splash/presentation/view_model/splash_cubit.dart';
import '../view_model/signup/register_bloc.dart';
import 'login_view.dart';
import '../../../../app/constants/theme_constant.dart';

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
  final TextEditingController _emailOrPhoneController2 = TextEditingController();
  final TextEditingController _starSignController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController.text = widget.emailOrPhone;
    _gender = "Male";
  }

  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted || await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      print("Picked file from ImagePicker: $image");
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
          print("Picked image: ${_profileImage?.path}");
          context.read<RegisterBloc>().add(UploadImage(file: _profileImage!));
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return 'Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return 'Sagittarius';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return 'Capricorn';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return 'Aquarius';
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces';
    return '';
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
        title: const Text("Register"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: customTheme.scaffoldGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? ThemeConstant.largePadding : ThemeConstant.mediumPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: theme.colorScheme.surface,
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(ThemeConstant.mediumBorderRadius),
                          ),
                        ),
                        builder: (context) => Padding(
                          padding: EdgeInsets.all(ThemeConstant.mediumPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  checkCameraPermission();
                                  _browseImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.camera,
                                  size: isTablet ? ThemeConstant.mediumIconSize : ThemeConstant.smallIconSize,
                                ),
                                label: Text(
                                  'Camera',
                                  style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _browseImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.image,
                                  size: isTablet ? ThemeConstant.mediumIconSize : ThemeConstant.smallIconSize,
                                ),
                                label: Text(
                                  'Gallery',
                                  style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: isTablet ? 250 : 200,
                      width: isTablet ? 250 : 200,
                      child: CircleAvatar(
                        radius: isTablet ? 75 : 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_gender == 'Female'
                                ? const AssetImage('assets/images/default_female.png')
                                : _gender == 'Other'
                                    ? const AssetImage('assets/images/default_profile.png')
                                    : const AssetImage('assets/images/default_male.png')) as ImageProvider,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
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
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Gender:',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
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
                          activeColor: theme.colorScheme.primary,
                        ),
                        Text(
                          'Male',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Radio<String>(
                          value: 'Female',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                        Text(
                          'Female',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Radio<String>(
                          value: 'Other',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                        Text(
                          'Other',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: TextEditingController(
                    text: _birthDate == null ? '' : DateFormat('yyyy/MM/dd').format(_birthDate!),
                  ),
                  decoration: const InputDecoration(
                    labelText: "Birthdate",
                  ),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
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
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  enabled: false,
                  controller: _starSignController,
                  decoration: const InputDecoration(
                    labelText: "Star Sign",
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
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
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: _emailOrPhoneController2,
                  decoration: InputDecoration(
                    labelText: widget.isEmail ? "Phone Number" : "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your ${widget.isEmail ? 'phone number' : 'email'}.";
                    }
                    return null;
                  },
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Bio (Optional)",
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.largePadding),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeConstant.smallPadding),
                      child: Text(
                        "Login credentials",
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
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: TextEditingController(text: widget.emailOrPhone),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "userName",
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: theme.colorScheme.primary,
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
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: theme.colorScheme.primary,
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
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: customTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(ThemeConstant.largeBorderRadius),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final registerState = context.read<RegisterBloc>().state;
                          final imageName = registerState.imageName;

                          print("birthday $_birthDate");
                          final formattedBirthDate = DateFormat('yyyy-MM-dd').format(_birthDate!);

                          context.read<RegisterBloc>().add(
                                RegisterUser(
                                  context: context,
                                  email: widget.isEmail ? widget.emailOrPhone : _emailOrPhoneController2.text,
                                  phoneNumber: widget.isEmail ? _emailOrPhoneController2.text : widget.emailOrPhone,
                                  name: _nameController.text,
                                  gender: _gender ?? '',
                                  birthDate: formattedBirthDate,
                                  starSign: _starSignController.text,
                                  bio: _bioController.text,
                                  userName: widget.emailOrPhone,
                                  password: _passwordController.text,
                                  profilePhoto: imageName,
                                ),
                              );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: getIt<SplashCubit>(),
                                child: LoginView(),
                              ),
                            ),
                          );
                          showMySnackBar(
                            context: context,
                            message: 'User created Successfully',
                            color: Colors.green,
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}