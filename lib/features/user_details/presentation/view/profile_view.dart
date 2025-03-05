import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/core/theme/theme_cubit.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
import 'package:softwarica_student_management_bloc/features/photos/domain/entity/photo_entity.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_bloc.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_event.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_state.dart';
import 'package:softwarica_student_management_bloc/features/user_details/domain/entity/user_details_entity.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_event.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_state.dart';

import 'widgets/edit_field_modal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double logoutShakeThreshold = 50.0; // High threshold for logout
  static const int shakeCooldown = 1000;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LoginBloc>()),
        BlocProvider.value(value: getIt<UserDetailsBloc>()),
        BlocProvider.value(value: getIt<PhotosBloc>()),
      ],
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
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: customTheme.scaffoldGradient,
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Use SliverToBoxAdapter instead of SliverFillRemaining to allow scrolling
                SliverToBoxAdapter(
                  child: _ProfileContent(),
                ),
              ],
            ),
          ),
        ),
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
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    print('ProfileContent initState');
    _fetchData();
  }

  void _fetchData() {
    final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
    if (userId.isNotEmpty && !_hasFetched) {
      print('Dispatching FetchUserDetails and FetchPhotos for userId: $userId');
      if (!context.read<UserDetailsBloc>().isClosed) {
        context.read<UserDetailsBloc>().add(FetchUserDetails(userId));
      } else {
        print('UserDetailsBloc is closed, cannot dispatch FetchUserDetails');
      }
      if (!context.read<PhotosBloc>().isClosed) {
        context.read<PhotosBloc>().add(FetchPhotos(userId));
      } else {
        print('PhotosBloc is closed, cannot dispatch FetchPhotos');
      }
      _hasFetched = true;
    } else if (userId.isEmpty) {
      print('No userId available, skipping fetch events');
    }
  }

  Future<void> _pickAndUploadImage(BuildContext context, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      if (!context.read<PhotosBloc>().isClosed) {
        context.read<PhotosBloc>().add(UploadPhoto(userId, image));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        print(
            'ProfilePage rebuilding due to ThemeCubit state change: isDarkMode=${themeState.isDarkMode}');
        return BlocListener<UserDetailsBloc, UserDetailsState>(
          listener: (context, state) {
            print('UserDetailsBloc state changed: $state');
            if (state is UserDetailsError) {
              print('UserDetailsBloc error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
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
                      Text('Please log in to view your profile',
                          style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: ThemeConstant.mediumPadding),
                      Container(
                        decoration: BoxDecoration(
                          gradient: Theme.of(context)
                              .customThemeExtension
                              .buttonGradient,
                          borderRadius: BorderRadius.circular(
                              ThemeConstant.largeBorderRadius),
                        ),
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: Text('Go to Login',
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
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
                    return Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary));
                  } else if (detailsState is UserDetailsLoaded) {
                    final details = detailsState.userDetails;
                    return _buildProfileDetails(
                        context, authUser, details, screenWidth, isTablet);
                  } else if (detailsState is UserDetailsError) {
                    return Center(
                        child: Text('Error: ${detailsState.message}',
                            style: Theme.of(context).textTheme.bodyLarge));
                  }
                  print('UserDetailsBloc initial or unknown state');
                  return Center(
                      child: Text('No user details available yet',
                          style: Theme.of(context).textTheme.bodyLarge));
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileDetails(BuildContext context, AuthEntity authUser,
      UserDetailsEntity details, double screenWidth, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(
          isTablet ? ThemeConstant.largePadding : ThemeConstant.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<PhotosBloc, PhotosState>(
            listener: (context, state) {
              // Listener can remain empty if no specific action is needed
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
              return _buildPhotoGrid(authUser, photos, screenWidth, isTablet);
            },
          ),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.largePadding
                  : ThemeConstant.mediumPadding),
          _buildAddPhotoButton(screenWidth, authUser.userId!, isTablet),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.largePadding
                  : ThemeConstant.mediumPadding),
          _buildUserInfo(authUser, screenWidth, isTablet),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.largePadding * 1.5
                  : ThemeConstant.largePadding),
          Text(
            'Additional Info',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.mediumPadding
                  : ThemeConstant.smallPadding),
          _buildUserDetails(details, screenWidth, authUser.userId!, isTablet),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.largePadding * 1.5
                  : ThemeConstant.largePadding),
          Text(
            'Theme Settings',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.mediumPadding
                  : ThemeConstant.smallPadding),
          _buildThemeSettingsSection(context, screenWidth, isTablet),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.largePadding * 1.5
                  : ThemeConstant.largePadding),
          Text(
            'Security',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: ThemeConstant.errorColor),
          ),
          SizedBox(
              height: isTablet
                  ? ThemeConstant.mediumPadding
                  : ThemeConstant.smallPadding),
          _buildSecuritySection(context, screenWidth, isTablet),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(AuthEntity authUser, List<PhotoEntity> photos,
      double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
          isTablet ? ThemeConstant.mediumPadding : ThemeConstant.smallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        boxShadow: Theme.of(context).customThemeExtension.cardShadow,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing:
            isTablet ? ThemeConstant.mediumPadding : ThemeConstant.smallPadding,
        mainAxisSpacing:
            isTablet ? ThemeConstant.mediumPadding : ThemeConstant.smallPadding,
        children: [
          _buildPhotoCard(
            authUser.profilePhoto != null && authUser.profilePhoto!.isNotEmpty
                ? '${ApiEndpoints.profilePhotoUrl}${authUser.profilePhoto}'
                : null,
            isMain: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildPhotoCard(
            photos.isNotEmpty
                ? '${ApiEndpoints.userImageUrl}${photos[0].image}'
                : null,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildPhotoCard(
            photos.length > 1
                ? '${ApiEndpoints.userImageUrl}${photos[1].image}'
                : null,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildPhotoCard(
            photos.length > 2
                ? '${ApiEndpoints.userImageUrl}${photos[2].image}'
                : null,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildPhotoCard(
            photos.length > 3
                ? '${ApiEndpoints.userImageUrl}${photos[3].image}'
                : null,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildPhotoCard(
            photos.length > 4
                ? '${ApiEndpoints.userImageUrl}${photos[4].image}'
                : null,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String? photoUrl,
      {bool isMain = false,
      required double screenWidth,
      required bool isTablet}) {
    return Container(
      height: isMain
          ? (isTablet ? screenWidth * 0.2 : screenWidth * 0.3)
          : (isTablet ? screenWidth * 0.1 : screenWidth * 0.15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: isMain
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : Theme.of(context).customThemeExtension.cardShadow,
        border: isMain
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
            : null,
      ),
      child: photoUrl != null && photoUrl.isNotEmpty
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(ThemeConstant.mediumBorderRadius),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Image load error: $error');
                  return Icon(Icons.error,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5));
                },
              ),
            )
          : Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildAddPhotoButton(
      double screenWidth, String userId, bool isTablet) {
    return BlocListener<PhotosBloc, PhotosState>(
      listener: (context, state) {
        // Listener can remain empty if no specific action is needed
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).customThemeExtension.buttonGradient,
            borderRadius:
                BorderRadius.circular(ThemeConstant.largeBorderRadius),
          ),
          child: ElevatedButton(
            onPressed: () => _pickAndUploadImage(context, userId),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  vertical: isTablet
                      ? ThemeConstant.mediumPadding
                      : screenWidth * 0.0375),
            ),
            child: Text('Add Photos',
                style: Theme.of(context).textTheme.labelLarge),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(
      AuthEntity authUser, double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
          isTablet ? ThemeConstant.largePadding : screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        boxShadow: Theme.of(context).customThemeExtension.cardShadow,
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
                    .displayMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: ThemeConstant.smallPadding),
              Text(
                '${authUser.gender ?? 'N/A'}, ${authUser.starSign ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          IconButton(
            icon:
                Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/update_profile',
                  arguments: authUser);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(UserDetailsEntity details, double screenWidth,
      String userId, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
          isTablet ? ThemeConstant.mediumPadding : screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        boxShadow: Theme.of(context).customThemeExtension.cardShadow,
      ),
      child: Column(
        children: _fields.map((field) {
          final String? value = _getFieldValue(details, field['key'] as String);
          return _buildDetailRow(
            field['icon'] as IconData,
            field['label'] as String,
            value ?? 'Add',
            () => _showEditModal(context, field, value, userId),
            isTablet,
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

  Widget _buildDetailRow(IconData icon, String label, String value,
      VoidCallback onTap, bool isTablet) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: isTablet
                ? ThemeConstant.mediumPadding
                : ThemeConstant.smallPadding),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.primary,
                size: isTablet ? ThemeConstant.mediumIconSize : 24),
            SizedBox(width: ThemeConstant.mediumPadding),
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary),
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
          left: ThemeConstant.mediumPadding,
          right: ThemeConstant.mediumPadding,
          top: ThemeConstant.mediumPadding,
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

  Widget _buildThemeSettingsSection(
      BuildContext context, double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(
          isTablet ? ThemeConstant.mediumPadding : screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
        boxShadow: Theme.of(context).customThemeExtension.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dark Mode',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          Switch(
            value: context.watch<ThemeCubit>().state.isDarkMode,
            onChanged: (value) {
              context.read<ThemeCubit>().setDarkMode(value);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(
      BuildContext context, double screenWidth, bool isTablet) {
    return Column(
      children: [
        if (!_isChangingPassword) ...[
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: Theme.of(context).customThemeExtension.buttonGradient,
                borderRadius:
                    BorderRadius.circular(ThemeConstant.largeBorderRadius),
              ),
              child: ElevatedButton(
                onPressed: () => setState(() => _isChangingPassword = true),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: isTablet
                          ? ThemeConstant.mediumPadding
                          : screenWidth * 0.0375),
                ),
                child: Text('Change Password',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
          ),
          SizedBox(
              height:
                  isTablet ? ThemeConstant.mediumPadding : screenWidth * 0.04),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeConstant.errorColor,
                    ThemeConstant.errorColor.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(ThemeConstant.largeBorderRadius),
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeCubit>().logout(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: isTablet
                          ? ThemeConstant.mediumPadding
                          : screenWidth * 0.0375),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.onPrimary),
                    SizedBox(width: ThemeConstant.smallPadding),
                    Text('Log Out',
                        style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ),
            ),
          ),
        ] else ...[
          if (_error != null)
            Padding(
              padding: EdgeInsets.only(
                  bottom: isTablet
                      ? ThemeConstant.mediumPadding
                      : screenWidth * 0.02),
              child: Text(_error!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ThemeConstant.errorColor)),
            ),
          TextField(
            controller: _oldPasswordController,
            decoration: const InputDecoration(labelText: 'Old Password'),
            obscureText: true,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(
              height:
                  isTablet ? ThemeConstant.mediumPadding : screenWidth * 0.03),
          TextField(
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(
              height:
                  isTablet ? ThemeConstant.mediumPadding : screenWidth * 0.03),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(
              height:
                  isTablet ? ThemeConstant.largePadding : screenWidth * 0.05),
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
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isFormEmpty
                                ? LinearGradient(
                                    colors: [
                                      Colors.grey.shade200,
                                      Colors.grey.shade400
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : Theme.of(context)
                                    .customThemeExtension
                                    .buttonGradient,
                            borderRadius: BorderRadius.circular(
                                ThemeConstant.largeBorderRadius),
                          ),
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
                                  vertical: isTablet
                                      ? ThemeConstant.mediumPadding
                                      : screenWidth * 0.0375),
                            ),
                            child: Text(
                              isFormEmpty ? 'Cancel' : 'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: isFormEmpty
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
        SnackBar(
            content: Text('Cannot change password',
                style: Theme.of(context).textTheme.bodyLarge)),
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
