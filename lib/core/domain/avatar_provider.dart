
import '../../models/gender.dart';

class AvatarProvider {
  String getAssetNameByUsernameAndGender(String username, Gender gender) {
    switch (gender) {
      case Gender.female:
        final int index = username.hashCode % 4;
        return 'assets/images/woman-$index.png';
      case Gender.male:
        final int index = username.hashCode % 4;
        return 'assets/images/man-$index.png';
      case Gender.cat:
        return 'assets/images/cat.png';
    }
  }
}
