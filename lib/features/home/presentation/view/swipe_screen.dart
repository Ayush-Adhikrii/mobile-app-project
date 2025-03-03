// lib/features/home/presentation/view/swipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_event.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_state.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_bloc.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_event.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_state.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_event.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_state.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('SwipeScreen build called');
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<UserBloc>()),
        BlocProvider.value(value: getIt<UserDetailsBloc>()),
        BlocProvider.value(value: getIt<PhotosBloc>()),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          print('UserBloc state: $state');
          if (state is UserInitial) {
            print('Triggering FetchUsers');
            context.read<UserBloc>().add(const FetchUsers());
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const NoMatchesFound();
            }
            return SwipeCards(
                users: state.users, swipeFeedback: state.swipeFeedback);
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Loading matches...'));
        },
      ),
    );
  }
}

class SwipeCards extends StatefulWidget {
  final List<UserEntity> users;
  final String? swipeFeedback;

  const SwipeCards({super.key, required this.users, this.swipeFeedback});

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  int _currentIndex = 0;
  bool _isReady = false;
  bool _allCardsSwiped = false;
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    print('SwipeCards initState');
    if (widget.users.isNotEmpty) {
      print(
          'Fetching details and photos for user: ${widget.users[_currentIndex].id}');
      context
          .read<UserDetailsBloc>()
          .add(FetchUserDetails(widget.users[_currentIndex].id));
      context
          .read<PhotosBloc>()
          .add(FetchPhotos(widget.users[_currentIndex].id));
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _isReady = true;
          });
        }
      });
    } else {
      setState(() {
        _allCardsSwiped = true;
      });
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topGap = 90.0;
    final double availableHeight = MediaQuery.of(context).size.height - topGap;
    final double photoHeight = availableHeight * 0.8;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double extraPhotoHeight = screenWidth * 0.3;

    if (!_isReady || widget.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allCardsSwiped) {
      return const NoMatchesFound();
    }

    return Stack(
      children: [
        CardSwiper(
          controller: _swiperController,
          cardsCount: widget.users.length,
          numberOfCardsDisplayed: 1,
          padding: EdgeInsets.zero,
          cardBuilder: (context, index, percentX, percentY) {
            final user = widget.users[index];
            final photoUrl =
                user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                    ? '${ApiEndpoints.profilePhotoUrl}${user.profilePhoto}'
                    : '';
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: topGap),
                        Stack(
                          children: [
                            Container(
                              height: photoHeight,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        'Image load error for ${user.name}: $error');
                                    return const Icon(Icons.person,
                                        size: 100, color: Colors.grey);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 36,
                              left: 32,
                              child: Text(
                                '${user.name}, ${user.birthDate != null ? _calculateAge(user.birthDate!) : ''}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'About Me',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.bio!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 24),
                          BlocBuilder<UserDetailsBloc, UserDetailsState>(
                            builder: (context, detailsState) {
                              return BlocBuilder<PhotosBloc, PhotosState>(
                                builder: (context, photosState) {
                                  List<String> photos = [];
                                  List<Map<String, String>> details = [];

                                  if (photosState is PhotosLoaded) {
                                    photos = photosState.photos
                                        .where((photo) => photo.image != null)
                                        .map((photo) =>
                                            '${ApiEndpoints.userImageUrl}${photo.image}')
                                        .toList();
                                    print('Photos loaded for UI: $photos');
                                  } else if (photosState is PhotosLoading) {
                                    print('PhotosBloc still loading');
                                  } else if (photosState is PhotosError) {
                                    print(
                                        'PhotosBloc error: ${photosState.message}');
                                  }

                                  if (detailsState is UserDetailsLoaded) {
                                    final userDetails =
                                        detailsState.userDetails;
                                    details = [
                                      {
                                        'label': 'Profession',
                                        'value': userDetails.profession ?? ''
                                      },
                                      {
                                        'label': 'Education',
                                        'value': userDetails.education ?? ''
                                      },
                                      {
                                        'label': 'Height',
                                        'value': userDetails.height != null
                                            ? userDetails.height!
                                                .toStringAsFixed(1)
                                            : ''
                                      },
                                      {
                                        'label': 'Exercise',
                                        'value': userDetails.exercise ?? ''
                                      },
                                      {
                                        'label': 'Drinks',
                                        'value': userDetails.drinks ?? ''
                                      },
                                      {
                                        'label': 'Smoke',
                                        'value': userDetails.smoke ?? ''
                                      },
                                      {
                                        'label': 'Kids',
                                        'value': userDetails.kids ?? ''
                                      },
                                      {
                                        'label': 'Religion',
                                        'value': userDetails.religion ?? ''
                                      },
                                    ]
                                        .where((detail) =>
                                            detail['value']!.isNotEmpty)
                                        .toList();
                                    print('Filtered details for UI: $details');
                                  }

                                  List<Widget> combinedWidgets = [];
                                  int maxLength = photos.length > details.length
                                      ? photos.length
                                      : details.length;
                                  for (int i = 0; i < maxLength; i++) {
                                    if (i < photos.length) {
                                      combinedWidgets.add(_buildPhotoWidget(
                                          photos[i], screenWidth * 0.3));
                                    }
                                    if (i < details.length) {
                                      combinedWidgets.add(_buildDetailRow(
                                        _getIconForLabel(details[i]['label']!),
                                        details[i]['label']!,
                                        details[i]['value']!,
                                      ));
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (details.isNotEmpty ||
                                          photos.isNotEmpty)
                                        const Text(
                                          'More About Me',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                      ...combinedWidgets,
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
          onSwipe: (previousIndex, currentIndex, direction) {
            final user = widget.users[previousIndex];
            if (direction == CardSwiperDirection.right) {
              context.read<UserBloc>().add(SwipeRight(user.id));
            } else if (direction == CardSwiperDirection.left) {
              context.read<UserBloc>().add(SwipeLeft(user.id));
            }
            print(
                'Swiped ${user.name} to ${direction == CardSwiperDirection.right ? "Like" : "Nope"}');
            if (currentIndex != null && currentIndex < widget.users.length) {
              _currentIndex = currentIndex;
              print(
                  'Fetching details and photos for next user: ${widget.users[currentIndex].id}');
              context
                  .read<UserDetailsBloc>()
                  .add(FetchUserDetails(widget.users[currentIndex].id));
              context
                  .read<PhotosBloc>()
                  .add(FetchPhotos(widget.users[currentIndex].id));
            } else {
              // All cards have been swiped
              setState(() {
                _allCardsSwiped = true;
              });
            }
            return true;
          },
          allowedSwipeDirection:
              const AllowedSwipeDirection.symmetric(horizontal: true),
        ),
        if (widget.swipeFeedback != null)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                widget.swipeFeedback == 'liked' ? 'Liked!' : 'Passed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.swipeFeedback == 'liked'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhotoWidget(String photoUrl, double height) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Photo load error: $error');
              return const Icon(Icons.error, size: 50, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Profession':
        return Icons.work;
      case 'Education':
        return Icons.school;
      case 'Height':
        return Icons.height;
      case 'Exercise':
        return Icons.fitness_center;
      case 'Drinks':
        return Icons.local_drink;
      case 'Smoke':
        return Icons.smoke_free;
      case 'Kids':
        return Icons.family_restroom;
      case 'Religion':
        return Icons.church;
      default:
        return Icons.info;
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
      print('Error parsing birthDate: $birthDate - $e');
      return 0;
    }
  }
}

class NoMatchesFound extends StatelessWidget {
  const NoMatchesFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 80,
            color: Colors.pink,
          ),
          const SizedBox(height: 16),
          const Text(
            "You have swiped through all of your preferred users",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Try changing your filter, and if that doesn’t work either, try touching some grass perhaps?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/preferences');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Change Filters",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
