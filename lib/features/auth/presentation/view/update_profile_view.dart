// lib/features/auth/presentation/view/update_profile_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_bloc.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_event.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/edit_profile/edit_profile_state.dart';

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
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final maxDate = DateTime(now.year - 16, now.month, now.day);
    final minDate = DateTime(1980); // Consistent with RegisterView

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Edit Profile'),
            backgroundColor: Colors.transparent,
            elevation: 0,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _pickProfilePhoto,
                    child: CircleAvatar(
                      radius: 80, // Larger avatar
                      backgroundImage: _profilePhoto != null
                          ? FileImage(_profilePhoto!)
                          : widget.authUser.profilePhoto != null
                              ? NetworkImage(
                                  '${ApiEndpoints.profilePhotoUrl}${widget.authUser.profilePhoto}')
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: 'Full Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
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
                            activeColor: ThemeConstant.primaryColor,
                          ),
                          Text(g),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                        labelText: 'Birth Date', border: OutlineInputBorder()),
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
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _starSignController,
                    decoration: const InputDecoration(
                        labelText: 'Star Sign', border: OutlineInputBorder()),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                        labelText: 'Bio', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                        labelText: 'Username', border: OutlineInputBorder()),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ).copyWith(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        shadowColor: WidgetStateProperty.all(
                            Colors.black.withOpacity(0.3)),
                      ),
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
