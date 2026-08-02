import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../core/services/native_input_service.dart';

class EmojiPanel extends ConsumerStatefulWidget {
  const EmojiPanel({super.key});

  @override
  ConsumerState<EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends ConsumerState<EmojiPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  static const List<String> smileys = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '🥹', '😊',
    '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙',
    '😚', '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎',
    '🥸', '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁',
    '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😮‍💨', '😤', '😠',
    '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥',
    '🤗', 'Thinking', '🤫', '🫠', '🫡', '🫣', '🤖', '👾', '👻', '💀'
  ];

  static const List<String> animalsAndNature = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨',
    '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🙈', '🙉', '🙊', '🐒',
    '🐔', '🐧', '🐦', '🐤', '🐣', '🐥', '🦆', '🦅', '🦉', '🦇',
    '🐺', '🐗', '🐴', '🦄', '🐝', '🪱', '🐛', '🦋', '🐌', '🐞',
    '🌸', '🌺', '🌻', '🌹', '🌷', '🌿', '🌱', '🌴', '🍀', '🍁'
  ];

  static const List<String> foodAndDrink = [
    '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐',
    '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🥑', '🍆',
    '🍟', '🍕', '🍔', '🌭', '🥪', '🌮', '🌯', '🫔', '🥙', '🧆',
    '🧋', '☕', '🍵', '🧃', '🥤', '🍺', '🍻', '🥂', '🍷', '🥃'
  ];

  static const List<String> kaomoji = [
    '(◕‿◕)', '(╯°□°)╯︵ ┻━┻', '¯\\_(ツ)_/¯', '( ͡° ͜ʖ ͡°)', '┬─┬ノ( º _ ºノ)',
    '(•_•)', '( •_•)>⌐■-■', '(⌐■_■)', '(⊙_⊙)', '(¬_¬)', '(>_<)', '(T_T)',
    'ʕ•ᴥ•ʔ', '(•⩊•)', 'ฅ^•ﻌ•^ฅ', '(｡♥‿♥｡)', '(ᗒᗣᗕ)', '(x_x)', '└(°-°)┐',
    '(*^▽^*)', '(o^▽^o)', '(≧◡≦)', '(σ≧▽≦)σ', '(⁄ ⁄>⁄ ▽ ⁄<⁄ ⁄)', '(,,>ヮ<,,)'
  ];

  static const List<String> symbolsAndFlags = [
    '🔥', '✨', '⚡', '⭐', '🌟', '💎', '🎉', '🎊', '❤️', '💖',
    '💗', '💓', '💞', '💕', '💯', '🚀', '👑', '🏆', '🎯', '💡',
    '🇱🇰', '🇺🇸', '🇬🇧', '🇮🇳', '🇯🇵', '🇰🇷', '🇨🇦', '🇦🇺', '🇩🇪', '🇫🇷'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).activeTheme;

    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: Column(
        children: [
          // Emoji Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
              height: 32,
              child: TextField(
                onChanged: (q) => setState(() => _searchQuery = q),
                style: TextStyle(color: theme.keyTextColor, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search Emojis & Kaomoji...',
                  hintStyle: TextStyle(color: theme.keyTextColor.withOpacity(0.5)),
                  prefixIcon: Icon(Icons.search, size: 14, color: theme.keyTextColor),
                  filled: true,
                  fillColor: theme.keyColor,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: theme.accentColor,
            labelColor: theme.accentColor,
            unselectedLabelColor: theme.keyTextColor.withOpacity(0.6),
            isScrollable: true,
            tabs: const [
              Tab(text: '😀 Smileys'),
              Tab(text: '🐶 Animals'),
              Tab(text: '🍕 Food'),
              Tab(text: 'ฅ^•ﻌ•^ฅ Kaomoji'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGrid(smileys, theme),
                _buildGrid(animalsAndNature, theme),
                _buildGrid(foodAndDrink, theme),
                _buildKaomojiList(kaomoji, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<String> items, dynamic theme) {
    final filtered = _searchQuery.isEmpty
        ? items
        : items.where((e) => e.contains(_searchQuery)).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return InkWell(
          onTap: () => NativeInputService.commitText(item),
          child: Center(
            child: Text(
              item,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKaomojiList(List<String> items, dynamic theme) {
    final filtered = _searchQuery.isEmpty
        ? items
        : items.where((e) => e.contains(_searchQuery)).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return InkWell(
          onTap: () => NativeInputService.commitText(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.keyColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.borderColor),
            ),
            child: Text(
              item,
              style: TextStyle(color: theme.keyTextColor, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
