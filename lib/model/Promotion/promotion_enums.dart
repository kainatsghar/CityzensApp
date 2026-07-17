enum AdPosition {
  launchPage('LaunchPage'),
  homePage('HomePage'),
  dashboard('Dashboard');

  final String value;
  const AdPosition(this.value);

  static AdPosition fromString(String? value) {
    return AdPosition.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdPosition.launchPage,
    );
  }
}

enum PromotionType {
  image('image'),
  video('video');

  final String value;
  const PromotionType(this.value);

  static PromotionType fromString(String? value) {
    return PromotionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PromotionType.image,
    );
  }
}
