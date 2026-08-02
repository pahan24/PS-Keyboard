import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/clipboard_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/native_input_service.dart';

class ClipboardPanel extends ConsumerWidget {
  const ClipboardPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).activeTheme;
    final state = ref.watch(clipboardProvider);
    final notifier = ref.read(clipboardProvider.notifier);

    final filteredClips = state.clips.where((clip) {
      if (state.searchQuery.isEmpty) return true;
      final text = clip['text'].toString().toLowerCase();
      return text.contains(state.searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: Column(
        children: [
          // Header Search Bar & Clear Action
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    onChanged: (q) => notifier.setSearchQuery(q),
                    style: TextStyle(color: theme.keyTextColor, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Search clipboard clips...',
                      hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search, size: 16, color: theme.keyTextColor),
                      filled: true,
                      fillColor: theme.keyColor,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_sweep, color: Colors.redAccent.shade100, size: 20),
                tooltip: 'Clear History',
                onPressed: () => notifier.clearAll(),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Clips Grid / List
          Expanded(
            child: filteredClips.isEmpty
                ? Center(
                    child: Text(
                      'No clips found in history',
                      style: TextStyle(color: theme.keyTextColor.withOpacity(0.6), fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredClips.length,
                    itemBuilder: (context, index) {
                      final item = filteredClips[index];
                      final text = item['text'] as String;
                      final isPinned = item['isPinned'] as bool? ?? false;

                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.keyColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isPinned ? theme.accentColor : theme.borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainState.spaceBetween,
                              children: [
                                Icon(
                                  isPinned ? Icons.push_pin : Icons.content_paste,
                                  size: 14,
                                  color: isPinned ? theme.accentColor : theme.keyTextColor.withOpacity(0.7),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.close, size: 14, color: theme.keyTextColor.withOpacity(0.5)),
                                  onPressed: () => notifier.deleteClip(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  NativeInputService.commitText(text);
                                },
                                child: Text(
                                  text,
                                  style: TextStyle(color: theme.keyTextColor, fontSize: 12),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
