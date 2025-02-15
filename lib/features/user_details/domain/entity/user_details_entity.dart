import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  final String userId;
  final String? profession;
  final String? education;
  final double? height;
  final String? exercise;
  final String? drinks;
  final String? smoke;
  final String? kids;
  final String? religion;

  const UserDetails({
    required this.userId,
    this.profession,
    this.education,
    this.height,
    this.exercise,
    this.drinks,
    this.smoke,
    this.kids,
    this.religion,
  });

  const UserDetails.empty()
      : userId = 'empty_user_id',
        profession = 'empty_profession',
        education = 'empty_education',
        height = 0.0,
        exercise = 'empty_exercise',
        drinks = 'empty_drinks',
        smoke = 'empty_smoke',
        kids = 'empty_kids',
        religion = 'empty_religion';

  @override
  List<Object?> get props => [
        userId,
        profession,
        education,
        height,
        exercise,
        drinks,
        smoke,
        kids,
        religion,
      ];
}
