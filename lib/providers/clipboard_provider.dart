import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/storage_service.dart';
import '../core/services/clipboard_service.dart';

class ClipboardState {
  final List<Map<String, dynamic>> clips;
  final String? detectedPskText;
  final String searchQuery;

  const ClipboardState({
    this.clips = const [],
    this.detectedPskText,
    this.searchQuery = '',
  });

  ClipboardState copyWith({
    List<Map<String, dynamic>>? clips,
    String? detectedPskText,
    String? searchQuery,
  }) {
    return ClipboardState(
      clips: clips ?? this.clips,
      detectedPskText: detectedPskText,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ClipboardNotifier extends StateNotifier<ClipboardState> {
  ClipboardNotifier() : super(const ClipboardState()) {
    loadClips();
    checkClipboardForPsk();
  }

  void loadClips() {
    final clips = StorageService.getClipboardClips();
    state = state.copyWith(clips: clips);
  }

  Future<void> checkClipboardForPsk() async {
    final pskText = await ClipboardService.checkSystemClipboardForPSK();
    loadClips();
    if (pskText != null) {
      state = state.copyWith(detectedPskText: pskText);
    }
  }

  void addClip(String text) async {
    await StorageService.addClipboardClip(text);
    loadClips();
  }

  void deleteClip(int index) async {
    await StorageService.deleteClipboardClip(index);
    loadClips();
  }

  void clearAll() async {
    await StorageService.clearClipboardHistory();
    loadClips();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void dismissPskBanner() {
    state = state.copyWith(detectedPskText: null);
  }
}

final clipboardProvider = StateNotifierProvider<ClipboardNotifier, ClipboardState>((ref) {
  return ClipboardNotifier();
});
