class TextToolsService {
  static const Map<String, String> _circleMap = {
    'a': 'ⓐ', 'b': 'ⓑ', 'c': 'ⓒ', 'd': 'ⓓ', 'e': 'ⓔ', 'f': 'ⓕ', 'g': 'ⓖ',
    'h': 'ⓗ', 'i': 'ⓘ', 'j': 'ⓙ', 'k': 'ⓚ', 'l': 'ⓛ', 'm': 'ⓜ', 'n': 'ⓝ',
    'o': 'ⓞ', 'p': 'ⓟ', 'q': 'ⓠ', 'r': 'ⓡ', 's': 'ⓢ', 't': 'ⓣ', 'u': 'ⓤ',
    'v': 'ⓥ', 'w': 'ⓦ', 'x': 'ⓧ', 'y': 'ⓨ', 'z': 'ⓩ',
    'A': 'Ⓐ', 'B': 'Ⓑ', 'C': 'Ⓒ', 'D': 'Ⓓ', 'E': 'Ⓔ', 'F': 'Ⓕ', 'G': 'Ⓖ',
    'H': 'Ⓗ', 'I': 'Ⓘ', 'J': 'Ⓙ', 'K': 'Ⓚ', 'L': 'Ⓛ', 'M': 'Ⓜ', 'N': 'Ⓝ',
    'O': 'Ⓞ', 'P': 'Ⓟ', 'Q': 'Ⓠ', 'R': 'Ⓡ', 'S': 'Ⓢ', 'T': 'Ⓣ', 'U': 'Ⓤ',
    'V': 'Ⓥ', 'W': 'Ⓦ', 'X': 'Ⓧ', 'Y': 'Ⓨ', 'Z': 'Ⓩ',
    '0': '⓪', '1': '①', '2': '②', '3': '③', '4': '④', '5': '⑤', '6': '⑥', '7': '⑦', '8': '⑧', '9': '⑨'
  };

  static const Map<String, String> _squareMap = {
    'a': '🄰', 'b': '🄱', 'c': '🄲', 'd': '🄳', 'e': '🄴', 'f': '🄵', 'g': '🄷',
    'h': '🄷', 'i': '🄸', 'j': '🄹', 'k': '🄺', 'l': '🄻', 'm': '🄼', 'n': '🄽',
    'o': '🄾', 'p': '🄿', 'q': '🅀', 'r': '🅁', 's': '🅂', 't': '🅃', 'u': '🅄',
    'v': '🅅', 'w': '🅆', 'x': '🅇', 'y': '🅈', 'z': '🅉',
    'A': '🄰', 'B': '🄱', 'C': '🄲', 'D': '🄳', 'E': '🄴', 'F': '🄵', 'G': '🄷',
    'H': '🄷', 'I': '🄸', 'J': '🄹', 'K': '🄺', 'L': '🄻', 'M': '🄼', 'N': '🄽',
    'O': '🄾', 'P': '🄿', 'Q': '🅀', 'R': '🅁', 'S': '🅂', 'T': '🅃', 'U': '🅄',
    'V': '🅅', 'W': '🅆', 'X': '🅇', 'Y': '🅈', 'Z': '🅉'
  };

  static String toUppercase(String input) => input.toUpperCase();

  static String toLowercase(String input) => input.toLowerCase();

  static String toTitleCase(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String toReverse(String input) => input.split('').reversed.join();

  static String toCircles(String input) {
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_circleMap[char] ?? char);
    }
    return buffer.toString();
  }

  static String toSquares(String input) {
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_squareMap[char] ?? char);
    }
    return buffer.toString();
  }

  static String toFullwidth(String input) {
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final code = input.codeUnitAt(i);
      if (code >= 33 && code <= 126) {
        buffer.writeCharCode(code + 65248);
      } else if (code == 32) {
        buffer.writeCharCode(12288);
      } else {
        buffer.write(input[i]);
      }
    }
    return buffer.toString();
  }

  static Map<String, String> generateAllStyles(String text) {
    final base = text.isEmpty ? 'Cyber PS Keyboard' : text;
    return {
      'Uppercase': toUppercase(base),
      'Lowercase': toLowercase(base),
      'Title Case': toTitleCase(base),
      'Reverse': toReverse(base),
      'Circles': toCircles(base),
      'Squares': toSquares(base),
      'Cyber Fullwidth': toFullwidth(base),
      'Fancy Gothic': '𝔉𝔞𝔫𝔠𝔶 $base',
      'Bold Serif': '𝐁𝐨𝐥𝐝 $base',
      'Script Cursive': '𝓒𝓾𝓻𝓼𝓲𝓿𝓮 $base',
      'Monospace': '𝙼𝚘𝚗𝚘𝚜𝚙𝚊𝚌𝚎 $base',
      'Small Caps': 'ꜱᴍᴀʟʟ ᴄᴀᴘꜱ $base',
      'Double Struck': '𝔻𝕠𝕦𝕓𝕝𝕖 $base',
    };
  }
}
