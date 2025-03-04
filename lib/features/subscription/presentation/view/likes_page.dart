// lib/features/subscription/presentation/pages/likes_page.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_event.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_state.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_bloc.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_event.dart';
import 'package:softwarica_student_management_bloc/features/photos/presentation/view_model/bloc/photos_state.dart';
import 'package:softwarica_student_management_bloc/features/subscription/presentation/view_model/bloc/subscription_bloc.dart';
import 'package:softwarica_student_management_bloc/features/subscription/presentation/view_model/bloc/subscription_event.dart';
import 'package:softwarica_student_management_bloc/features/subscription/presentation/view_model/bloc/subscription_state.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_bloc.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_event.dart';
import 'package:softwarica_student_management_bloc/features/user_details/presentation/view_model/bloc/user_details_state.dart';

import '../../data/datasources/payment_service.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LoginBloc>()),
        BlocProvider.value(value: getIt<UserBloc>()),
        BlocProvider.value(value: getIt<SubscriptionBloc>()),
        BlocProvider.value(value: getIt<UserDetailsBloc>()),
        BlocProvider.value(value: getIt<PhotosBloc>()),
      ],
      child: Builder(
        builder: (context) {
          final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
          if (userId.isNotEmpty) {
            // Only fetch subscription status initially
            context
                .read<SubscriptionBloc>()
                .add(GetSubscriptionExpiryEvent(userId));
          } else {
            print('No userId available, skipping subscription fetch');
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Likes'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFCE4EC), Color(0xFFE1BEE7)],
                ),
              ),
              child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, subscriptionState) {
                  print('SubscriptionBloc state: $subscriptionState');
                  bool isSubscribed = false;
                  if (subscriptionState is SubscriptionLoaded) {
                    isSubscribed = subscriptionState.isValid;
                    print(
                        'Subscription state: Loaded, Is subscribed: $isSubscribed');
                  } else if (subscriptionState is SubscriptionNotFound) {
                    isSubscribed = subscriptionState.isValid;
                    print(
                        'Subscription state: NotFound, Is subscribed: $isSubscribed');
                  } else if (subscriptionState is SubscriptionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (subscriptionState is SubscriptionError) {
                    return Center(
                        child: Text('Error: ${subscriptionState.message}'));
                  }

                  // Fetch likers only if subscribed
                  if (isSubscribed && userId.isNotEmpty) {
                    context.read<UserBloc>().add(FetchLikers(userId));
                  }

                  if (!isSubscribed) {
                    print('Showing SubscriptionPrompt');
                    return SubscriptionPrompt(userId: userId);
                  }

                  return BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                      print('UserBloc state: $userState');
                      if (userState is UserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (userState is LikersLoaded) {
                        print(
                            'Likers loaded with swipeFeedback: ${userState.swipeFeedback}');
                        if (userState.likers.isEmpty) {
                          return const NoLikersFound();
                        }
                        return LikerArea(
                            likers: userState.likers,
                            swipeFeedback: userState.swipeFeedback);
                      } else if (userState is UserError) {
                        return Center(
                            child: Text('Error: ${userState.message}'));
                      }
                      return const Center(child: Text('Loading likers...'));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubscriptionPrompt extends StatelessWidget {
  final String userId;

  const SubscriptionPrompt({super.key, required this.userId});

  Future<void> _initiatePayment({
    required BuildContext context,
    required String subscriptionType,
    required double amount,
  }) async {
    try {
      // Call the backend to create a payment order
      final paymentService = getIt<PaymentService>();
      final response = await paymentService.createPayment(
        userId: userId,
        subscriptionType: subscriptionType,
        amount: amount.toInt(),
      );

      final formData = response['formData'];

      // Configure eSewa payment
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test, // Use test environment for sandbox
          clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
          secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
        ),
        esewaPayment: EsewaPayment(
          productId: formData['transaction_uuid'],
          productName: '$subscriptionType Subscription',
          productPrice: amount.toString(), // Pass the price (300, 500, 800)
          callbackUrl: formData['success_url'],
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) async {
          await _handlePaymentSuccess(
              context, result, userId, subscriptionType);
        },
        onPaymentFailure: (data) {
          _handlePaymentFailure(context, data);
        },
        onPaymentCancellation: (data) {
          _handlePaymentCancellation(context, data);
        },
      );
    } catch (e) {
      print('Error initiating payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating payment: $e')),
      );
    }
  }

  Future<void> _handlePaymentSuccess(
      BuildContext context,
      EsewaPaymentSuccessResult result,
      String userId,
      String subscriptionType) async {
    try {
      print("Payment success result: $result");

      // Since onPaymentSuccess is called, we assume the payment is successful
      const String status =
          "COMPLETE"; // Hardcoding since onPaymentSuccess implies success

      // Notify the backend of the payment success
      final dio = Dio();
      dio.options.validateStatus =
          (status) => true; // Accept all status codes to handle 404 gracefully
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}payment/success',
        data: {
          'userId': userId,
          'subscriptionType': subscriptionType,
          'status': status,
        },
      );

      print("Backend response after payment success: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the subscription status
        context
            .read<SubscriptionBloc>()
            .add(GetSubscriptionExpiryEvent(userId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful! Subscription added.'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the page by popping and pushing the same route
        Navigator.pop(context); // Pop the current LikesPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LikesPage()), // Push a new instance of LikesPage
        );
      } else {
        throw Exception(
            'Failed to update subscription: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print("Error notifying backend of payment success: $e");
      // Show a generic error message, but still attempt to refresh subscription status
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Payment succeeded, but there was an issue updating the subscription. Please refresh.'),
          backgroundColor: Colors.orange,
        ),
      );
      // Refresh the subscription status anyway, in case it was saved
      context.read<SubscriptionBloc>().add(GetSubscriptionExpiryEvent(userId));
    }
  }

  void _handlePaymentFailure(BuildContext context, dynamic data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: $data'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handlePaymentCancellation(BuildContext context, dynamic data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Cancelled: $data'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Unlock Who Liked You!",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            "Subscribe now to view your admirers.",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await _initiatePayment(
                    context: context,
                    subscriptionType: 'Silver',
                    amount: 300, // Set price for Silver to 300 NPR
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/esewa_logo.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    const Text("Silver - 1 Month"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[500],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await _initiatePayment(
                    context: context,
                    subscriptionType: 'Gold',
                    amount: 500, // Set price for Gold to 500 NPR
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/esewa_logo.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    const Text("Gold - 3 Months"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[500],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await _initiatePayment(
                    context: context,
                    subscriptionType: 'Platinum',
                    amount: 800, // Set price for Platinum to 800 NPR
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/esewa_logo.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    const Text("Platinum - 6 Months"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoLikersFound extends StatelessWidget {
  const NoLikersFound({super.key});

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
            "You have no new likers",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Try adding your details and updating your photos.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Update Profile",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class LikerArea extends StatefulWidget {
  final List<UserEntity> likers;
  final String? swipeFeedback;

  const LikerArea({super.key, required this.likers, this.swipeFeedback});

  @override
  _LikerAreaState createState() => _LikerAreaState();
}

class _LikerAreaState extends State<LikerArea> {
  int _currentIndex = 0;
  bool _isReady = false;
  bool _allCardsSwiped = false;
  bool _showFeedback = false;
  final CardSwiperController _swiperController = CardSwiperController();
  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    print('LikerArea initState');
    if (widget.likers.isNotEmpty) {
      print(
          'Fetching details and photos for user: ${widget.likers[_currentIndex].id}');
      context
          .read<UserDetailsBloc>()
          .add(FetchUserDetails(widget.likers[_currentIndex].id));
      context
          .read<PhotosBloc>()
          .add(FetchPhotos(widget.likers[_currentIndex].id));
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
  void didUpdateWidget(covariant LikerArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.swipeFeedback != oldWidget.swipeFeedback &&
        widget.swipeFeedback != null) {
      setState(() {
        _showFeedback = true;
      });
      _feedbackTimer?.cancel();
      _feedbackTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topGap = 90.0;
    final double availableHeight = MediaQuery.of(context).size.height - topGap;
    final double photoHeight = availableHeight * 0.8;
    final double screenWidth = MediaQuery.of(context).size.width;

    if (!_isReady || widget.likers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allCardsSwiped) {
      return const NoLikersFound();
    }

    return Stack(
      children: [
        CardSwiper(
          controller: _swiperController,
          cardsCount: widget.likers.length,
          numberOfCardsDisplayed: 1,
          padding: EdgeInsets.zero,
          cardBuilder: (context, index, percentX, percentY) {
            final user = widget.likers[index];
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
a
                                  List<Widget> combinedWidgets = [];
                                  int maxLength = photos.length > details.length
                                      ? photos.length
                                      : details.length;
                                  for (int i = 0; i < maxLength; i++) {
                                    if (i < photos.length) {
                                      combinedWidgets.add(_buildPhotoWidget(
                                          photos[i], photoHeight));
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
            final user = widget.likers[previousIndex];
            if (direction == CardSwiperDirection.right) {
              context.read<UserBloc>().add(SwipeRight(user.id));
            } else if (direction == CardSwiperDirection.left) {
              context.read<UserBloc>().add(SwipeLeft(user.id));
            }
            print(
                'Swiped ${user.name} to ${direction == CardSwiperDirection.right ? "Like" : "Nope"}');
            if (currentIndex != null && currentIndex < widget.likers.length) {
              _currentIndex = currentIndex;
              print(
                  'Fetching details and photos for next user: ${widget.likers[currentIndex].id}');
              context
                  .read<UserDetailsBloc>()
                  .add(FetchUserDetails(widget.likers[currentIndex].id));
              context
                  .read<PhotosBloc>()
                  .add(FetchPhotos(widget.likers[currentIndex].id));
            } else {
              setState(() {
                _allCardsSwiped = true;
              });
            }
            return true;
          },
          allowedSwipeDirection:
              const AllowedSwipeDirection.symmetric(horizontal: true),
        ),
        if (_showFeedback && widget.swipeFeedback != null)
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
