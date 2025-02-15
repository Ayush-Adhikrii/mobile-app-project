part of 'user_details_bloc.dart';

sealed class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

class UserDetails extends UserDetailsEvent {
  final BuildContext context;
  final String? profession;
  final String? education;
  final double? height;
  final String? exercise;
  final String? drinks;
  final String? smoke;
  final String? kids;
  final String? religion;

  const UserDetails({
    required this.context,
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  @override
  List<Object> get props => [
        context,
        profession ?? '',
        education ?? '',
        height ?? 0.0,
        exercise ?? '',
        drinks ?? '',
        smoke ?? '',
        kids ?? '',
        religion ?? '',
      ];
}
