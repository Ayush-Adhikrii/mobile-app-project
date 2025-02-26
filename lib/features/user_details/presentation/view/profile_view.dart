// lib/features/user_details/presentation/pages/profile_page.dart (updated)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_event.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_state.dart';

import '../../../photos/domain/entity/photo_entity.dart';
import '../../../photos/presentation/view_model/bloc/photos_bloc.dart';
import '../../../photos/presentation/view_model/bloc/photos_event.dart';
import '../../../photos/presentation/view_model/bloc/photos_state.dart';
import 'widgets/edit_field_modal.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('ProfilePage build called');
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LoginBloc>()),
        BlocProvider.value(value: getIt<UserDetailsBloc>()),
        BlocProvider.value(value: getIt<PhotosBloc>()),
      ],
      child: Builder(
        builder: (context) {
          final userId = getIt<LoginBloc>().state.authUser?.userId ?? '';
          if (userId.isNotEmpty) {
            if (!context.read<UserDetailsBloc>().isClosed) {
              context.read<UserDetailsBloc>().add(FetchUserDetails(userId));
            } else {
              print('UserDetailsBloc is closed, skipping FetchUserDetails');
            }
            if (!context.read<PhotosBloc>().isClosed) {
              context.read<PhotosBloc>().add(FetchPhotos(userId));
            } else {
              print('PhotosBloc is closed, skipping FetchPhotos');
            }
          } else {
            print('No userId available, skipping fetch events');
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFCE4EC), Color(0xFFE1BEE7)],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: const Text('My Profile'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    titleTextStyle:
                        Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  SliverToBoxAdapter(child: _ProfileContent()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatefulWidget {
  @override
  __ProfileContentState createState() => __ProfileContentState();
}

class __ProfileContentState extends State<_ProfileContent> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isChangingPassword = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    print('ProfileContent initState');
    final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
    if (userId.isNotEmpty && !context.read<PhotosBloc>().isClosed) {
      context.read<PhotosBloc>().add(FetchPhotos(userId));
    }
  }

  Future<void> _pickAndUploadImage(BuildContext context, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      if (!context.read<PhotosBloc>().isClosed) {
        context.read<PhotosBloc>().add(UploadPhoto(userId, image));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo upload unavailable')),
        );
      }
    } else {
      print('No image selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        print(
            'LoginBloc state: isLoading=${loginState.isLoading}, isSuccess=${loginState.isSuccess}, authUser=${loginState.authUser}');
        final authUser = loginState.authUser;
        if (authUser == null) {
          print('authUser is null, showing login prompt');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please log in to view your profile'),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          );
        }
        return BlocBuilder<UserDetailsBloc, UserDetailsState>(
          builder: (context, detailsState) {
            print('UserDetailsBloc state: $detailsState');
            if (detailsState is UserDetailsLoading) {
              print('UserDetailsBloc is loading');
              return const Center(child: CircularProgressIndicator());
            } else if (detailsState is UserDetailsLoaded) {
              final details = detailsState.userDetails;
              return _buildProfileDetails(
                  context, authUser, details, screenWidth);
            } else if (detailsState is UserDetailsError) {
              print('UserDetailsBloc error: ${detailsState.message}');
              return Center(child: Text('Error: ${detailsState.message}'));
            }
            print('UserDetailsBloc initial or unknown state');
            return const Center(child: Text('No user details available yet'));
          },
        );
      },
    );
  }

  Widget _buildProfileDetails(BuildContext context, AuthEntity authUser,
      UserDetailsEntity details, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<PhotosBloc, PhotosState>(
            listener: (context, state) {
              if (state is PhotosError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              } else if (state is PhotosLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photos updated')),
                );
                if (!context.read<PhotosBloc>().isClosed) {
                  context.read<PhotosBloc>().add(FetchPhotos(authUser.userId!));
                }
              }
            },
            builder: (context, photosState) {
              List<PhotoEntity> photos = [];
              if (photosState is PhotosLoaded) {
                photos = photosState.photos
                    .where((photo) =>
                        photo.image!.isNotEmpty &&
                        photo.userId == authUser.userId)
                    .toList();
                print(
                    'Photos loaded for user ${authUser.userId}: ${photos.map((p) => p.image)}');
              } else if (photosState is PhotosError) {
                print('PhotosBloc error: ${photosState.message}');
              } else if (photosState is PhotosLoading) {
                print('PhotosBloc is loading');
              }
              return _buildPhotoGrid(authUser, photos, screenWidth);
            },
          ),
          SizedBox(height: screenWidth * 0.05),
          _buildAddPhotoButton(screenWidth, authUser.userId!),
          SizedBox(height: screenWidth * 0.05),
          _buildUserInfo(authUser, screenWidth),
          SizedBox(height: screenWidth * 0.075),
          Text(
            'Additional Info',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: screenWidth * 0.03),
          _buildUserDetails(details, screenWidth, authUser.userId!),
          SizedBox(height: screenWidth * 0.075),
          Text(
            'Security',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.redAccent),
          ),
          SizedBox(height: screenWidth * 0.03),
          _buildSecuritySection(context, screenWidth),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(
      AuthEntity authUser, List<PhotoEntity> photos, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: screenWidth * 0.025,
        mainAxisSpacing: screenWidth * 0.025,
        children: [
          _buildPhotoCard(
            authUser.profilePhoto != null && authUser.profilePhoto!.isNotEmpty
                ? '${ApiEndpoints.profilePhotoUrl}${authUser.profilePhoto}'
                : null,
            isMain: true,
            screenWidth: screenWidth,
          ),
          _buildPhotoCard(
            photos.isNotEmpty
                ? '${ApiEndpoints.userImageUrl}${photos[0].image}'
                : null,
            screenWidth: screenWidth,
          ),
          _buildPhotoCard(
            photos.length > 1
                ? '${ApiEndpoints.userImageUrl}${photos[1].image}'
                : null,
            screenWidth: screenWidth,
          ),
          _buildPhotoCard(
            photos.length > 2
                ? '${ApiEndpoints.userImageUrl}${photos[2].image}'
                : null,
            screenWidth: screenWidth,
          ),
          _buildPhotoCard(
            photos.length > 3
                ? '${ApiEndpoints.userImageUrl}${photos[3].image}'
                : null,
            screenWidth: screenWidth,
          ),
          _buildPhotoCard(
            photos.length > 4
                ? '${ApiEndpoints.userImageUrl}${photos[4].image}'
                : null,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String? photoUrl,
      {bool isMain = false, required double screenWidth}) {
    return Container(
      height: isMain ? screenWidth * 0.3 : screenWidth * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: photoUrl != null && photoUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Image load error: $error');
                  return const Icon(Icons.error);
                },
              ),
            )
          : const Icon(Icons.add, color: ThemeConstant.primaryColor),
    );
  }

  Widget _buildAddPhotoButton(double screenWidth, String userId) {
    return BlocListener<PhotosBloc, PhotosState>(
      listener: (context, state) {
        if (state is PhotosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading photo: ${state.message}')),
          );
        } else if (state is PhotosLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo uploaded successfully')),
          );
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _pickAndUploadImage(context, userId),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
          ).copyWith(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
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
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
              child: const Text('Add Photos', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(AuthEntity authUser, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${authUser.name}, ${_calculateAge(authUser.birthDate ?? '')}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${authUser.gender ?? 'N/A'}, ${authUser.starSign ?? 'N/A'}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: ThemeConstant.primaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/update_profile',
                  arguments: authUser);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(
      UserDetailsEntity details, double screenWidth, String userId) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _fields.map((field) {
          final String? value = _getFieldValue(details, field['key'] as String);
          return _buildDetailRow(
            field['icon'] as IconData,
            field['label'] as String,
            value ?? 'Add',
            () => _showEditModal(context, field, value, userId),
          );
        }).toList(),
      ),
    );
  }

  String? _getFieldValue(UserDetailsEntity details, String key) {
    switch (key) {
      case 'profession':
        return details.profession;
      case 'height':
        return details.height?.toString();
      case 'education':
        return details.education;
      case 'exercise':
        return details.exercise;
      case 'drinks':
        return details.drinks;
      case 'smoke':
        return details.smoke;
      case 'kids':
        return details.kids;
      case 'religion':
        return details.religion;
      default:
        return null;
    }
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: ThemeConstant.primaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: ThemeConstant.primaryColor),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, Map<String, dynamic> field,
      String? currentValue, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          left: 16,
          right: 16,
          top: 16,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: EditFieldModal(
            field: field['key'] as String,
            title: field['label'] as String,
            icon: field['icon'] as IconData,
            currentValue: currentValue ?? '',
            onSave: (key, value) {
              if (!context.read<UserDetailsBloc>().isClosed) {
                context
                    .read<UserDetailsBloc>()
                    .add(UpdateUserDetails(userId, key, value));
                Navigator.pop(modalContext);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot update details')),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        if (!_isChangingPassword) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isChangingPassword = true),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                shadowColor:
                    WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
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
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
                  child: const Text('Change Password',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().logout(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                shadowColor:
                    WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0375),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Log Out', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          TextField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(labelText: 'Old Password'),
            obscureText: true,
          ),
          SizedBox(height: screenWidth * 0.03),
          TextField(
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
          SizedBox(height: screenWidth * 0.03),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          SizedBox(height: screenWidth * 0.05),
          ValueListenableBuilder(
            valueListenable: _oldPasswordController,
            builder: (context, oldValue, _) => ValueListenableBuilder(
              valueListenable: _newPasswordController,
              builder: (context, newValue, _) => ValueListenableBuilder(
                valueListenable: _confirmPasswordController,
                builder: (context, confirmValue, _) {
                  final bool isFormEmpty = oldValue.text.isEmpty &&
                      newValue.text.isEmpty &&
                      confirmValue.text.isEmpty;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isFormEmpty) {
                              setState(() {
                                _isChangingPassword = false;
                                _error = null;
                                _oldPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              });
                            } else {
                              _handleChangePassword(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.0375),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                            foregroundColor:
                                isFormEmpty ? Colors.grey[600] : Colors.white,
                            backgroundColor: isFormEmpty
                                ? Colors.grey[200]
                                : Colors.transparent,
                          ).copyWith(
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Ink(
                            decoration: !isFormEmpty
                                ? BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ThemeConstant.primaryColor,
                                        ThemeConstant.primaryColor
                                            .withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  )
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.0375),
                              child: Text(
                                isFormEmpty ? 'Cancel' : 'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isFormEmpty ? null : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _handleChangePassword(BuildContext context) {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }

    if (!context.read<LoginBloc>().isClosed) {
      context.read<LoginBloc>().add(ChangePasswordEvent(
            oldPassword: oldPassword,
            newPassword: newPassword,
            context: context,
          ));
      setState(() {
        _isChangingPassword = false;
        _error = null;
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot change password')),
      );
    }
  }

  int _calculateAge(String birthDate) {
    try {
      final normalizedDate = birthDate.replaceAll('/', '-');
      final birth = DateTime.parse(normalizedDate);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) age--;
      return age;
    } catch (e) {
      print('Error calculating age: $e');
      return 0;
    }
  }
}

const _fields = [
  {'key': 'profession', 'label': 'Profession', 'icon': Icons.work},
  {'key': 'height', 'label': 'Height', 'icon': Icons.height},
  {'key': 'education', 'label': 'Education', 'icon': Icons.school},
  {'key': 'exercise', 'label': 'Exercise', 'icon': Icons.fitness_center},
  {'key': 'drinks', 'label': 'Drinks', 'icon': Icons.local_drink},
  {'key': 'smoke', 'label': 'Smoke', 'icon': Icons.smoke_free},
  {'key': 'kids', 'label': 'Kids', 'icon': Icons.family_restroom},
  {'key': 'religion', 'label': 'Religion', 'icon': Icons.church},
];
