class SinhalaConverterService {
  // Consonant Phonetic map for Singlish -> Sinhala Unicode
  static const Map<String, String> _consonants = {
    'k': 'ක', 'kh': 'ඛ', 'g': 'ග', 'gh': 'ඝ', 'nng': 'ඟ',
    'ch': 'ච', 'chh': 'ඡ', 'j': 'ජ', 'jh': 'ඣ', 'nny': 'ඤ',
    't': 'ත', 'th': 'ථ', 'd': 'ද', 'dh': 'ධ', 'nnd': 'ඳ',
    'T': 'ට', 'Th': 'ඨ', 'D': 'ඩ', 'Dh': 'ඪ', 'N': 'ණ',
    'p': 'ප', 'ph': 'ඵ', 'b': 'බ', 'bh': 'භ', 'mmb': 'ඹ',
    'm': 'ම', 'y': 'ය', 'r': 'ර', 'l': 'ල', 'v': 'ව', 'w': 'ව',
    'sh': 'ශ', 'Sh': 'ෂ', 's': 'ස', 'h': 'හ', 'L': 'ළ', 'f': 'ෆ', 'x': 'ං'
  };

  // Independent Vowels map
  static const Map<String, String> _vowels = {
    'a': 'අ', 'aa': 'ආ', 'ae': 'ඇ', 'aae': 'ඈ',
    'i': 'ඉ', 'ii': 'ඊ', 'u': 'උ', 'uu': 'ඌ',
    'e': 'එ', 'ee': 'ඒ', 'o': 'ඔ', 'oo': 'ඕ', 'au': 'ඖ', 'ir': 'ඍ'
  };

  // Vowel Modifiers (Pili)
  static const Map<String, String> _pili = {
    'aa': 'ා', 'ae': 'ැ', 'aae': 'ෑ',
    'i': 'ි', 'ii': 'ී', 'u': 'ු', 'uu': 'ූ',
    'e': 'ෙ', 'ee': 'ේ', 'o': 'ො', 'oo': 'ෝ', 'au': 'ෞ', 'ru': 'ෘ'
  };

  /// Translate a Phonetic Singlish word into Sinhala Unicode
  static String convertPhonetic(String input) {
    if (input.isEmpty) return '';

    String text = input;
    final StringBuffer result = StringBuffer();

    int i = 0;
    while (i < text.length) {
      bool matched = false;

      // Check 3-char consonant combinations (nng, nnd, mmb, etc.)
      if (i + 3 <= text.length) {
        final sub3 = text.substring(i, i + 3);
        if (_consonants.containsKey(sub3)) {
          result.write(_consonants[sub3]);
          i += 3;
          continue;
        }
      }

      // Check 2-char combinations (kh, gh, ch, th, dh, sh, etc.)
      if (i + 2 <= text.length) {
        final sub2 = text.substring(i, i + 2);
        if (_consonants.containsKey(sub2)) {
          result.write(_consonants[sub2]);
          i += 2;
          continue;
        }
        if (_vowels.containsKey(sub2) && i == 0) {
          result.write(_vowels[sub2]);
          i += 2;
          continue;
        }
        if (_pili.containsKey(sub2) && i > 0) {
          result.write(_pili[sub2]);
          i += 2;
          continue;
        }
      }

      // 1-char match
      final char = text[i];
      if (_consonants.containsKey(char)) {
        result.write(_consonants[char]);
        matched = true;
      } else if (_vowels.containsKey(char)) {
        if (i == 0 || (i > 0 && text[i - 1] == ' ')) {
          result.write(_vowels[char]);
        } else {
          result.write(_pili[char] ?? '');
        }
        matched = true;
      }

      if (!matched) {
        result.write(char);
      }
      i++;
    }

    return result.toString();
  }

  // Complete Wijesekera traditional key map
  static const Map<String, String> wijesekeraNormal = {
    'q': 'ු', 'w': 'අ', 'e': 'ැ', 'r': 'ර', 't': 'එ', 'y': 'හ', 'u': 'ම', 'i': 'ස', 'o': 'ද', 'p': 'ච',
    'a': '්', 's': 'ි', 'd': 'ා', 'f': 'ෙ', 'g': 'ට', 'h': 'ය', 'j': 'ව', 'k': 'න', 'l': 'ක',
    'z': 'ූ', 'x': 'ං', 'c': 'ජ', 'v': 'ඩ', 'b': 'ඊ', 'n': 'බ', 'm': 'ප',
    '[': 'ඤ', ']': 'ඡ', ';': 'ත', "'": 'ති', '/': 'ල', '.': 'ග', ',': 'ල'
  };

  static const Map<String, String> wijesekeraShift = {
    'Q': 'ෲ', 'W': 'උ', 'E': 'ෑ', 'R': 'ඍ', 'T': 'ඔ', 'Y': 'ශ', 'U': 'ඹ', 'I': 'ෂ', 'O': 'ධ', 'P': 'ඡ',
    'A': 'ෟ', 'S': 'ී', 'D': 'ෘ', 'F': 'ෆ', 'G': 'ඨ', 'H': '්‍ය', 'J': 'ළු', 'K': 'ණ', 'L': 'ඛ',
    'Z': 'ෳ', 'X': 'ඃ', 'C': 'ඣ', 'V': 'ඪ', 'B': 'භ', 'N': 'ඞ', 'M': 'ඵ',
    '{': 'ඥ', '}': 'ඨ', ':': 'ථ', '"': 'ධ', '?': 'ළ', '>': 'ඝ', '<': 'ඟ'
  };
}
