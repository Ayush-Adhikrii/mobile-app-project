import 'package:equatable/equatable.dart';

class UserDetailsEntity extends Equatable {
  final String userId;
  final String? profession;
  final String? education;
  final double? height;
  final String? exercise;
  final String? drinks;
  final String? smoke;
  final String? kids;
  final String? religion;

  const UserDetailsEntity({
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

  const UserDetailsEntity.empty()
      : userId = 'empty_user_id',
        profession = 'empty_profession',
        education = 'empty_education',
        height = 0.0,
        exercise = 'empty_exercise',
        drinks = 'empty_drinks',
        smoke = 'empty_smoke',
        kids = 'empty_kids',
        religion = 'empty_religion';

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profession': profession,
      'education': education,
      'height': height,
      'exercise': exercise,
      'drinks': drinks,
      'smoke': smoke,
      'kids': kids,
      'religion': religion,
    };
  }

  UserDetailsEntity copyWith({
    String? userId,
    String? profession,
    String? education,
    double? height,
    String? exercise,
    String? drinks,
    String? smoke,
    String? kids,
    String? religion,
  }) {
    return UserDetailsEntity(
      userId: userId ?? this.userId,
      profession: profession ?? this.profession,
      education: education ?? this.education,
      height: height ?? this.height,
      exercise: exercise ?? this.exercise,
      drinks: drinks ?? this.drinks,
      smoke: smoke ?? this.smoke,
      kids: kids ?? this.kids,
      religion: religion ?? this.religion,
    );
  }

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