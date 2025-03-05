import 'dart:async';

import 'package:dio/dio.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/domain/entity/user_entity.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_bloc.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_event.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/bloc/user_state.dart';
import 'package:softwarica_student_management_bloc/features/home/presentation/view_model/home_cubit.dart';
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

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  String? _swipeMessage;
  Timer? _timer;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double logoutShakeThreshold = 50.0; // High threshold for logout
  static const int shakeCooldown = 1000;

  void _showSwipeMessage(String message) {
    setState(() {
      _swipeMessage = message;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _swipeMessage = null;
        });
      }
    });
  }

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
    _timer?.cancel();
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
        BlocProvider.value(value: getIt<UserBloc>()),
        BlocProvider.value(value: getIt<SubscriptionBloc>()),
        BlocProvider.value(value: getIt<UserDetailsBloc>()),
        BlocProvider.value(value: getIt<PhotosBloc>()),
      ],
      child: Builder(
        builder: (context) {
          final userId = context.read<LoginBloc>().state.authUser?.userId ?? '';
          if (userId.isNotEmpty) {
            context
                .read<SubscriptionBloc>()
                .add(GetSubscriptionExpiryEvent(userId));
          } else {
            print('No userId available, skipping subscription fetch');
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              shadowColor: theme.colorScheme.onSurface.withOpacity(0.1),
              toolbarHeight: isTablet ? 40 : 30,
              leading: Padding(
                padding:
                    const EdgeInsets.only(left: ThemeConstant.smallPadding),
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
              backgroundColor: theme.appBarTheme.backgroundColor ??
                  theme.colorScheme.surface, // Adaptive color
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: customTheme.scaffoldGradient,
              ),
              child: Stack(
                children: [
                  BlocBuilder<SubscriptionBloc, SubscriptionState>(
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
                        return Center(
                            child: CircularProgressIndicator(
                                color: theme.colorScheme.primary));
                      } else if (subscriptionState is SubscriptionError) {
                        return Center(
                            child: Text('Error: ${subscriptionState.message}',
                                style: theme.textTheme.bodyLarge));
                      }

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
                            return Center(
                                child: CircularProgressIndicator(
                                    color: theme.colorScheme.primary));
                          } else if (userState is LikersLoaded) {
                            print(
                                'Likers loaded with swipeFeedback: ${userState.swipeFeedback}');
                            if (userState.likers.isEmpty) {
                              return const NoLikersFound();
                            }
                            return LikerArea(
                              likers: userState.likers,
                              onSwipe: _showSwipeMessage,
                              isTablet: isTablet,
                            );
                          } else if (userState is UserError) {
                            return Center(
                                child: Text('Error: ${userState.message}',
                                    style: theme.textTheme.bodyLarge));
                          }
                          return Center(
                              child: Text('Loading likers...',
                                  style: theme.textTheme.bodyLarge));
                        },
                      );
                    },
                  ),
                  if (_swipeMessage != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          _swipeMessage!,
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: _swipeMessage == 'Matched!'
                                ? ThemeConstant.successColor
                                : ThemeConstant.errorColor,
                          ),
                        ),
                      ),
                    ),
                ],
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
      final paymentService = getIt<PaymentService>();
      final response = await paymentService.createPayment(
        userId: userId,
        subscriptionType: subscriptionType,
        amount: amount.toInt(),
      );

      final formData = response['formData'];

      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R',
          secretId: 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==',
        ),
        esewaPayment: EsewaPayment(
          productId: formData['transaction_uuid'],
          productName: '$subscriptionType Subscription',
          productPrice: amount.toString(),
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
    final theme = Theme.of(context);

    try {
      print("Payment success result: $result");

      const String status = "COMPLETE";

      final dio = Dio();
      dio.options.validateStatus = (status) => true;
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
        context
            .read<SubscriptionBloc>()
            .add(GetSubscriptionExpiryEvent(userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Successful! Subscription added.',
                style: theme.textTheme.bodyLarge),
            backgroundColor: ThemeConstant.successColor,
          ),
        );
      } else {
        throw Exception(
            'Failed to update subscription: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print("Error notifying backend of payment success: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment succeeded, but there was an issue updating the subscription. Please refresh.',
            style: theme.textTheme.bodyLarge,
          ),
          backgroundColor: ThemeConstant.warningColor,
        ),
      );
      context.read<SubscriptionBloc>().add(GetSubscriptionExpiryEvent(userId));
    }
  }

  void _handlePaymentFailure(BuildContext context, dynamic data) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Payment Failed: $data', style: theme.textTheme.bodyLarge),
        backgroundColor: ThemeConstant.errorColor,
      ),
    );
  }

  void _handlePaymentCancellation(BuildContext context, dynamic data) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Payment Cancelled: $data', style: theme.textTheme.bodyLarge),
        backgroundColor: ThemeConstant.warningColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet
            ? ThemeConstant.largePadding
            : ThemeConstant.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Unlock Who Liked You!",
              style: theme.textTheme.displayMedium,
            ),
            SizedBox(height: ThemeConstant.mediumPadding),
            Text(
              "Subscribe now to view your admirers.",
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: ThemeConstant.largePadding),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(ThemeConstant.mediumBorderRadius),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet
                            ? ThemeConstant.mediumPadding
                            : ThemeConstant.smallPadding,
                        horizontal: isTablet
                            ? ThemeConstant.largePadding
                            : ThemeConstant.mediumPadding,
                      ),
                    ),
                    onPressed: () async {
                      await _initiatePayment(
                          context: context,
                          subscriptionType: 'Silver',
                          amount: 300);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/esewa_logo.png',
                          height: isTablet ? 32 : 24,
                          width: isTablet ? 32 : 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: ThemeConstant.smallPadding),
                        Text("Silver - 1 Month",
                            style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                Container(
                  decoration: BoxDecoration(
                    gradient: customTheme.buttonGradient,
                    borderRadius:
                        BorderRadius.circular(ThemeConstant.mediumBorderRadius),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet
                            ? ThemeConstant.mediumPadding
                            : ThemeConstant.smallPadding,
                        horizontal: isTablet
                            ? ThemeConstant.largePadding
                            : ThemeConstant.mediumPadding,
                      ),
                    ),
                    onPressed: () async {
                      await _initiatePayment(
                          context: context,
                          subscriptionType: 'Gold',
                          amount: 500);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/esewa_logo.png',
                          height: isTablet ? 32 : 24,
                          width: isTablet ? 32 : 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: ThemeConstant.smallPadding),
                        Text("Gold - 3 Months",
                            style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstant.mediumPadding),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade500, Colors.purple.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(ThemeConstant.mediumBorderRadius),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet
                            ? ThemeConstant.mediumPadding
                            : ThemeConstant.smallPadding,
                        horizontal: isTablet
                            ? ThemeConstant.largePadding
                            : ThemeConstant.mediumPadding,
                      ),
                    ),
                    onPressed: () async {
                      await _initiatePayment(
                          context: context,
                          subscriptionType: 'Platinum',
                          amount: 800);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/esewa_logo.png',
                          height: isTablet ? 32 : 24,
                          width: isTablet ? 32 : 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: ThemeConstant.smallPadding),
                        Text("Platinum - 6 Months",
                            style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoLikersFound extends StatelessWidget {
  const NoLikersFound({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet
            ? ThemeConstant.largePadding
            : ThemeConstant.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: isTablet
                  ? ThemeConstant.largeIconSize * 1.5
                  : ThemeConstant.largeIconSize,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: ThemeConstant.mediumPadding),
            Text(
              "You have no new likers",
              style: theme.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeConstant.smallPadding),
            Text(
              "Try adding your details and updating your photos.",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeConstant.largePadding),
            Container(
              decoration: BoxDecoration(
                gradient: customTheme.buttonGradient,
                borderRadius:
                    BorderRadius.circular(ThemeConstant.largeBorderRadius),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child:
                    Text("Update Profile", style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LikerArea extends StatefulWidget {
  final List<UserEntity> likers;
  final Function(String) onSwipe;
  final bool isTablet;

  const LikerArea({
    super.key,
    required this.likers,
    required this.onSwipe,
    required this.isTablet,
  });

  @override
  _LikerAreaState createState() => _LikerAreaState();
}

class _LikerAreaState extends State<LikerArea> {
  int _currentIndex = 0;
  bool _isReady = false;
  bool _allCardsSwiped = false;
  final CardSwiperController _swiperController = CardSwiperController();
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  DateTime? _lastSwipeTime;
  static const double swipeThreshold =
      5.0; // Reasonable threshold for gyroscope
  static const int swipeCooldown = 500; // Cooldown to prevent rapid swipes

  @override
  void initState() {
    super.initState();
    print('LikerArea initState');
    _initSwipeDetection();

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

  void _initSwipeDetection() {
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      final now = DateTime.now();
      if (_lastSwipeTime != null &&
          now.difference(_lastSwipeTime!).inMilliseconds < swipeCooldown) {
        return;
      }

      if (event.y > swipeThreshold) {
        _lastSwipeTime = now;
        _swiperController.swipe(CardSwiperDirection.right);
      } else if (event.y < -swipeThreshold) {
        _lastSwipeTime = now;
        _swiperController.swipe(CardSwiperDirection.left);
      }
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double topGap = widget.isTablet ? 120.0 : 15.0;
    final double availableHeight = MediaQuery.of(context).size.height - topGap;
    final double photoHeight = availableHeight * 0.8;
    final double extraPhotoHeight = MediaQuery.of(context).size.width * 0.5;

    if (!_isReady || widget.likers.isEmpty) {
      return Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary));
    }

    if (_allCardsSwiped) {
      return const NoLikersFound();
    }

    return CardSwiper(
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
        return Card(
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
                          margin: EdgeInsets.symmetric(
                              horizontal: ThemeConstant.mediumPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ThemeConstant.mediumBorderRadius),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                ThemeConstant.mediumBorderRadius),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                    'Image load error for ${user.name}: $error');
                                return Icon(
                                  Icons.person,
                                  size: widget.isTablet ? 120 : 100,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: widget.isTablet ? 48 : 36,
                          left: widget.isTablet ? 40 : 32,
                          child: Text(
                            '${user.name}, ${user.birthDate != null ? _calculateAge(user.birthDate!) : ''}',
                            style: theme.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              shadows: const [
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
                  padding: EdgeInsets.all(ThemeConstant.mediumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Me',
                            style: theme.textTheme.displayMedium,
                          ),
                          SizedBox(height: ThemeConstant.smallPadding),
                          if (user.gender != null && user.gender!.isNotEmpty)
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                      ThemeConstant.smallPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ThemeConstant.mediumBorderRadius),
                                    border: Border.all(
                                        color: theme.colorScheme.primary),
                                  ),
                                  child: Icon(
                                    _getGenderIcon(user.gender!),
                                    size: ThemeConstant.mediumIconSize,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: ThemeConstant.smallPadding),
                                Text(
                                  user.gender!,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          if (user.starSign != null &&
                              user.starSign!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ThemeConstant.smallPadding),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        ThemeConstant.smallPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ThemeConstant.mediumBorderRadius),
                                      border: Border.all(
                                          color: theme.colorScheme.primary),
                                    ),
                                    child: Icon(
                                      Icons.star_border,
                                      size: ThemeConstant.mediumIconSize,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(width: ThemeConstant.smallPadding),
                                  Text(
                                    user.starSign!,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ThemeConstant.smallPadding),
                              child: Text(
                                user.bio!,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: ThemeConstant.largePadding),
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
                                final userDetails = detailsState.userDetails;
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
                                        ? userDetails.height!.toStringAsFixed(1)
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
                                    .where(
                                        (detail) => detail['value']!.isNotEmpty)
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
                                      photos[i], extraPhotoHeight));
                                }
                                if (i < details.length) {
                                  combinedWidgets.add(_buildDetailRow(
                                    theme,
                                    _getIconForLabel(details[i]['label']!),
                                    details[i]['label']!,
                                    details[i]['value']!,
                                  ));
                                }
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (details.isNotEmpty || photos.isNotEmpty)
                                    Text(
                                      'More About Me',
                                      style: theme.textTheme.displayMedium,
                                    ),
                                  SizedBox(height: ThemeConstant.mediumPadding),
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
              SliverToBoxAdapter(
                  child: SizedBox(height: ThemeConstant.largePadding)),
            ],
          ),
        );
      },
      onSwipe: (previousIndex, currentIndex, direction) {
        final user = widget.likers[previousIndex];
        if (direction == CardSwiperDirection.right) {
          context.read<UserBloc>().add(SwipeRight(user.id));
          widget.onSwipe('Matched!');
        } else if (direction == CardSwiperDirection.left) {
          context.read<UserBloc>().add(SwipeLeft(user.id));
          widget.onSwipe('Passed!');
        }
        print(
            'Swiped ${user.name} to ${direction == CardSwiperDirection.right ? "Match" : "Nope"}');
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
    );
  }

  Widget _buildPhotoWidget(String photoUrl, double height) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstant.mediumPadding),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
          boxShadow: Theme.of(context).customThemeExtension.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstant.mediumBorderRadius),
          child: Image.network(
            photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Photo load error: $error');
              return Icon(
                Icons.error,
                size: ThemeConstant.mediumIconSize,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstant.mediumPadding),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: ThemeConstant.mediumIconSize,
          ),
          SizedBox(width: ThemeConstant.mediumPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
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

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      case 'other':
        return Icons.transgender;
      default:
        return Icons.person;
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
