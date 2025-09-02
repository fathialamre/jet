import 'dart:math';

class JetFaker {
  static final _random = Random();
  static const _adjectives = [
    'fast', 'cool', 'smart', 'brave', 'happy', 'lucky', 'fancy', 'wild', 'quiet', 'bright',
    'shiny', 'silly', 'witty', 'bold', 'calm', 'eager', 'fuzzy', 'jolly', 'kind', 'zany'
  ];
  static const _nouns = [
    'lion', 'tiger', 'eagle', 'panda', 'wolf', 'fox', 'bear', 'otter', 'owl', 'shark',
    'whale', 'falcon', 'rabbit', 'koala', 'monkey', 'moose', 'deer', 'hawk', 'lynx', 'gecko'
  ];

  /// Generates a random username in the format: adjective_noun123
  static String username() {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final noun = _nouns[_random.nextInt(_nouns.length)];
    final number = _random.nextInt(900) + 100; // 100-999
    return '${adjective}_${noun}$number';
  }
}
