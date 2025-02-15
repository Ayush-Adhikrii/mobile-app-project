import 'package:equatable/equatable.dart';

class PreferencesEntity extends Equatable {
  final String userId;
  final String? preferredGender;
  final int? minAge;
  final int? maxAge;
  final String? relationType;
  final String? preferredStarSign;
  final String? preferredReligion;

  const PreferencesEntity({
    required this.userId,
    this.preferredGender,
    this.minAge,
    this.maxAge,
    this.relationType,
    this.preferredStarSign,
    this.preferredReligion,
  });

  @override
  List<Object?> get props => [
        userId,
        preferredGender,
        minAge,
        maxAge,
        relationType,
        preferredStarSign,
        preferredReligion,
      ];
}
