enum Gender {
  cat,
  female,
  male,
}

Gender getGenderByCodeOrElse(String code, Gender orElse) {
    code = code.toLowerCase();
    switch (code) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'cat':
        return Gender.cat;
      default:
        return orElse;
    }
  }
