import 'package:flutter/material.dart';

enum LiveBackgroundType {
  none,
  matrix,
  galaxy,
  neonPulse,
  rgbWave,
  particles,
  aurora,
  rain,
  snow,
  fire,
  water
}

class KeyboardThemeData {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color keyColor;
  final Color keyTextColor;
  final Color specialKeyColor;
  final Color specialKeyTextColor;
  final Color accentColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double opacity;
  final double blurRadius;
  final double glowIntensity;
  final bool isRgbAnimated;
  final double rgbSpeed;
  final LiveBackgroundType liveBackground;
  final String fontFamily;

  const KeyboardThemeData({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.keyColor,
    required this.keyTextColor,
    required this.specialKeyColor,
    required this.specialKeyTextColor,
    required this.accentColor,
    required this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.opacity = 0.85,
    this.blurRadius = 10.0,
    this.glowIntensity = 0.0,
    this.isRgbAnimated = false,
    this.rgbSpeed = 1.0,
    this.liveBackground = LiveBackgroundType.none,
    this.fontFamily = 'Roboto',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'backgroundColor': backgroundColor.value,
    'keyColor': keyColor.value,
    'keyTextColor': keyTextColor.value,
    'specialKeyColor': specialKeyColor.value,
    'specialKeyTextColor': specialKeyTextColor.value,
    'accentColor': accentColor.value,
    'borderColor': borderColor.value,
    'borderWidth': borderWidth,
    'borderRadius': borderRadius,
    'opacity': opacity,
    'blurRadius': blurRadius,
    'glowIntensity': glowIntensity,
    'isRgbAnimated': isRgbAnimated,
    'rgbSpeed': rgbSpeed,
    'liveBackground': liveBackground.name,
    'fontFamily': fontFamily,
  };

  factory KeyboardThemeData.fromJson(Map<String, dynamic> json) {
    return KeyboardThemeData(
      id: json['id'] as String? ?? 'custom',
      name: json['name'] as String? ?? 'Custom Theme',
      backgroundColor: Color(json['backgroundColor'] as int? ?? 0xFF121212),
      keyColor: Color(json['keyColor'] as int? ?? 0xFF1E1E2C),
      keyTextColor: Color(json['keyTextColor'] as int? ?? 0xFFFFFFFF),
      specialKeyColor: Color(json['specialKeyColor'] as int? ?? 0xFF2A2A3D),
      specialKeyTextColor: Color(json['specialKeyTextColor'] as int? ?? 0xFF00E5FF),
      accentColor: Color(json['accentColor'] as int? ?? 0xFF00E5FF),
      borderColor: Color(json['borderColor'] as int? ?? 0xFF33334D),
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 8.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 0.85,
      blurRadius: (json['blurRadius'] as num?)?.toDouble() ?? 10.0,
      glowIntensity: (json['glowIntensity'] as num?)?.toDouble() ?? 0.0,
      isRgbAnimated: json['isRgbAnimated'] as bool? ?? false,
      rgbSpeed: (json['rgbSpeed'] as num?)?.toDouble() ?? 1.0,
      liveBackground: LiveBackgroundType.values.firstWhere(
        (e) => e.name == json['liveBackground'],
        orElse: () => LiveBackgroundType.none,
      ),
      fontFamily: json['fontFamily'] as String? ?? 'Roboto',
    );
  }

  // Preset Themes
  static const KeyboardThemeData cyberpunk = KeyboardThemeData(
    id: 'cyberpunk',
    name: 'Cyberpunk Neon',
    backgroundColor: Color(0xFF0D0221),
    keyColor: Color(0xFF190938),
    keyTextColor: Color(0xFF00F0FF),
    specialKeyColor: Color(0xFF2C0B5E),
    specialKeyTextColor: Color(0xFFFF007F),
    accentColor: Color(0xFFFF007F),
    borderColor: Color(0xFF00F0FF),
    borderWidth: 1.2,
    borderRadius: 6.0,
    opacity: 0.9,
    blurRadius: 15.0,
    glowIntensity: 0.8,
    isRgbAnimated: true,
    liveBackground: LiveBackgroundType.neonPulse,
  );

  static const KeyboardThemeData matrix = KeyboardThemeData(
    id: 'matrix',
    name: 'Matrix Code',
    backgroundColor: Color(0xFF020D04),
    keyColor: Color(0xFF051C09),
    keyTextColor: Color(0xFF00FF66),
    specialKeyColor: Color(0xFF0B3813),
    specialKeyTextColor: Color(0xFF33FF88),
    accentColor: Color(0xFF00FF66),
    borderColor: Color(0xFF00FF66),
    borderWidth: 1.0,
    borderRadius: 4.0,
    opacity: 0.88,
    blurRadius: 8.0,
    glowIntensity: 0.6,
    isRgbAnimated: false,
    liveBackground: LiveBackgroundType.matrix,
  );

  static const KeyboardThemeData amoledDark = KeyboardThemeData(
    id: 'amoled',
    name: 'AMOLED Pure Dark',
    backgroundColor: Color(0xFF000000),
    keyColor: Color(0xFF121212),
    keyTextColor: Color(0xFFFFFFFF),
    specialKeyColor: Color(0xFF1F1F1F),
    specialKeyTextColor: Color(0xFF80D8FF),
    accentColor: Color(0xFF40C4FF),
    borderColor: Color(0xFF262626),
    borderRadius: 10.0,
    opacity: 1.0,
    blurRadius: 0.0,
  );

  static const KeyboardThemeData glassLight = KeyboardThemeData(
    id: 'glass_light',
    name: 'Glassmorphism Light',
    backgroundColor: Color(0xD0F0F4F8),
    keyColor: Color(0xCCFFFFFF),
    keyTextColor: Color(0xFF1C1B1F),
    specialKeyColor: Color(0xB0E2E8F0),
    specialKeyTextColor: Color(0xFF0066FF),
    accentColor: Color(0xFF0066FF),
    borderColor: Color(0x60FFFFFF),
    borderRadius: 12.0,
    opacity: 0.8,
    blurRadius: 20.0,
  );

  static const KeyboardThemeData rgbRainbow = KeyboardThemeData(
    id: 'rgb_rainbow',
    name: 'RGB Gamer Wave',
    backgroundColor: Color(0xFF0F0F1A),
    keyColor: Color(0xFF1A1A2E),
    keyTextColor: Color(0xFFFFFFFF),
    specialKeyColor: Color(0xFF252542),
    specialKeyTextColor: Color(0xFF00FFF0),
    accentColor: Color(0xFFFF0055),
    borderColor: Color(0xFF00F0FF),
    borderWidth: 1.5,
    borderRadius: 8.0,
    glowIntensity: 1.0,
    isRgbAnimated: true,
    rgbSpeed: 1.5,
    liveBackground: LiveBackgroundType.rgbWave,
  );

  static const KeyboardThemeData spaceGalaxy = KeyboardThemeData(
    id: 'space_galaxy',
    name: 'Space Galaxy',
    backgroundColor: Color(0xFF060312),
    keyColor: Color(0xFF140D33),
    keyTextColor: Color(0xFFE2D6FF),
    specialKeyColor: Color(0xFF261956),
    specialKeyTextColor: Color(0xFFB388FF),
    accentColor: Color(0xFFD500F9),
    borderColor: Color(0xFF7C4DFF),
    borderRadius: 10.0,
    opacity: 0.85,
    blurRadius: 12.0,
    glowIntensity: 0.5,
    liveBackground: LiveBackgroundType.galaxy,
  );

  static const KeyboardThemeData natureEmerald = KeyboardThemeData(
    id: 'nature_emerald',
    name: 'Nature Emerald',
    backgroundColor: Color(0xFF051B14),
    keyColor: Color(0xFF0D382B),
    keyTextColor: Color(0xFFE0F2F1),
    specialKeyColor: Color(0xFF145340),
    specialKeyTextColor: Color(0xFF64FFDA),
    accentColor: Color(0xFF1DE9B6),
    borderColor: Color(0xFF26A69A),
    borderRadius: 8.0,
    opacity: 0.9,
    liveBackground: LiveBackgroundType.particles,
  );

  static const KeyboardThemeData luxuryGold = KeyboardThemeData(
    id: 'luxury_gold',
    name: 'Luxury Gold',
    backgroundColor: Color(0xFF14120E),
    keyColor: Color(0xFF2A241B),
    keyTextColor: Color(0xFFFFECB3),
    specialKeyColor: Color(0xFF3D3426),
    specialKeyTextColor: Color(0xFFFFD54F),
    accentColor: Color(0xFFFFC107),
    borderColor: Color(0xFFFFD700),
    borderRadius: 8.0,
    glowIntensity: 0.4,
  );

  static List<KeyboardThemeData> get allPresets => [
    cyberpunk,
    matrix,
    rgbRainbow,
    amoledDark,
    spaceGalaxy,
    glassLight,
    natureEmerald,
    luxuryGold,
  ];
}
