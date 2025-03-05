import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';

import '../../domain/entity/auth_entity.dart';
import '../view_model/edit_profile/edit_profile_bloc.dart';
import '../view_model/edit_profile/edit_profile_event.dart';
import '../view_model/edit_profile/edit_profile_state.dart';

class UpdateProfileView extends StatefulWidget {
  final AuthEntity authUser;

  const UpdateProfileView({super.key, required this.authUser});

  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _starSignController = TextEditingController();
  String? _gender;
  DateTime? _birthDate;
  File? _profilePhoto;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double logoutShakeThreshold = 50.0; // High threshold for logout
  static const int shakeCooldown = 1000;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.authUser.name;
    _emailController.text = widget.authUser.email!;
    _phoneNumberController.text = widget.authUser.phoneNumber ?? '';
    _bioController.text = widget.authUser.bio ?? '';
    _userNameController.text = widget.authUser.userName;
    _birthDate = widget.authUser.birthDate != null
        ? DateTime.parse(widget.authUser.birthDate!)
        : null;
    _birthDateController.text =
        _birthDate != null ? DateFormat('yyyy/MM/dd').format(_birthDate!) : '';
    _starSignController.text = widget.authUser.starSign ?? '';
    _gender = widget.authUser.gender ?? 'Male';
    _initLogoutDetection();
  }

  void _initLogoutDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final now = DateTime.now();
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!).inMilliseconds < shakeCooldown) {
        return;
      }

      if (event.x.abs() > logoutShakeThreshold ||
          event.y.abs() > logoutShakeThreshold ||
          event.z.abs() > logoutShakeThreshold) {
        _lastShakeTime = now;
        _logout(context);
      }
    });
  }

  void _logout(BuildContext context) {
    context.read<HomeCubit>().logout(context);
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profilePhoto = File(pickedFile.path));
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
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return 'Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return 'Sagittarius';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return 'Capricorn';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return 'Aquarius';
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces';
    return '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    _birthDateController.dispose();
    _starSignController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final maxDate = DateTime(now.year - 16, now.month, now.day);
    final minDate = DateTime(1980);
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider.value(
      value: getIt<EditProfileBloc>(),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pop(context);
            if (_profilePhoto != null &&
                !context.read<EditProfileBloc>().isClosed) {
              context.read<EditProfileBloc>().add(UploadProfilePhoto(
                    userId: widget.authUser.userId!,
                    image: _profilePhoto!,
                  ));
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            shadowColor: theme.colorScheme.onSurface.withOpacity(0.1),
            toolbarHeight: isTablet ? 40 : 30,
            leading: Padding(
              padding: const EdgeInsets.only(left: ThemeConstant.smallPadding),
              child: Image.asset(
                'assets/icons/plain_logo.png',
                height: isTablet ? 30 : 20,
                width: isTablet ? 30 : 20,
                fit: BoxFit.contain,
              ),
            ),
            leadingWidth: isTablet ? 40 : 30,
            title: Center(
              child: Image.asset(
                'assets/icons/text_logo.png',
                height: isTablet ? 30 : 20,
                fit: BoxFit.contain,
              ),
            ),
            backgroundColor: theme.colorScheme.surface,
            actions: [
              IconButton(
                icon:
                    Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: customTheme.scaffoldGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet
                    ? ThemeConstant.largePadding
                    : ThemeConstant.mediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _pickProfilePhoto,
                      child: CircleAvatar(
                        radius: isTablet ? 100 : 80,
                        backgroundImage: _profilePhoto != null
                            ? FileImage(_profilePhoto!)
                            : widget.authUser.profilePhoto != null
                                ? NetworkImage(
                                    '${ApiEndpoints.profilePhotoUrl}${widget.authUser.profilePhoto}')
                                : const AssetImage('assets/default_profile.png')
                                    as ImageProvider,
                      ),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Male', 'Female', 'Other'].map((g) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: g,
                              groupValue: _gender,
                              onChanged: (value) =>
                                  setState(() => _gender = value!),
                              activeColor: theme.colorScheme.primary,
                            ),
                            Text(g, style: theme.textTheme.bodyLarge),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _birthDateController,
                      decoration:
                          const InputDecoration(labelText: 'Birth Date'),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: maxDate,
                          firstDate: minDate,
                          lastDate: maxDate,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _birthDate = pickedDate;
                            _birthDateController.text =
                                DateFormat('yyyy/MM/dd').format(pickedDate);
                            _starSignController.text = _getStarSign(pickedDate);
                          });
                        }
                      },
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _starSignController,
                      decoration: const InputDecoration(labelText: 'Star Sign'),
                      readOnly: true,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _phoneNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 3,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                    TextField(
                      controller: _userNameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      readOnly: true,
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
                          if (_nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _userNameController.text.isNotEmpty) {
                            context.read<EditProfileBloc>().add(UpdateProfile(
                                  userId: widget.authUser.userId!,
                                  name: _nameController.text,
                                  gender: _gender!,
                                  email: _emailController.text,
                                  birthDate: _birthDate!,
                                  phoneNumber: _phoneNumberController.text,
                                  bio: _bioController.text,
                                  userName: _userNameController.text,
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please fill required fields (Name, Email, Username)')),
                            );
                          }
                        },
                        child: Text(
                          'Update Profile',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                    SizedBox(height: ThemeConstant.mediumPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
