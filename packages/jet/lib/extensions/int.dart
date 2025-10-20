extension JetSleepExtensions on int {
  Future<void> sleep() async {
    await Future.delayed(Duration(seconds: this));
  }
}
