import 'package:flutter/material.dart';

class SettingsData {
  final bool haptics;
  final bool sound;
  final int target;
  final String defaultDhikr;
  final ThemeMode themeMode;

  const SettingsData({
    required this.haptics,
    required this.sound,
    required this.target,
    required this.defaultDhikr,
    required this.themeMode,
  });

  SettingsData copyWith({
    bool? haptics,
    bool? sound,
    int? target,
    String? defaultDhikr,
    ThemeMode? themeMode,
  }) =>
      SettingsData(
        haptics: haptics ?? this.haptics,
        sound: sound ?? this.sound,
        target: target ?? this.target,
        defaultDhikr: defaultDhikr ?? this.defaultDhikr,
        themeMode: themeMode ?? this.themeMode,
      );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.initial});
  final SettingsData initial;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool haptics;
  late bool sound;
  late int target;
  late String defaultDhikr;
  late ThemeMode themeMode;

  final List<String> _dhikrOptions = const [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
    'Astaghfirullah',
  ];

  @override
  void initState() {
    super.initState();
    haptics = widget.initial.haptics;
    sound = widget.initial.sound;
    target = widget.initial.target;
    defaultDhikr = widget.initial.defaultDhikr;
    themeMode = widget.initial.themeMode;
  }

  void _saveAndClose() {
    Navigator.of(context).pop(
      SettingsData(
        haptics: haptics,
        sound: sound,
        target: target,
        defaultDhikr: defaultDhikr,
        themeMode: themeMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [TextButton(onPressed: _saveAndClose, child: const Text('Save'))],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _sectionHeader(context, 'Preferences'),
          _card(
            context,
            children: [
              SwitchListTile.adaptive(
                value: haptics,
                onChanged: (v) => setState(() => haptics = v),
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Enable haptic feedback for each Dhikr count'),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                value: sound,
                onChanged: (v) => setState(() => sound = v),
                title: const Text('Sound'),
                subtitle: const Text('Enable sound for each Dhikr count'),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                value: themeMode == ThemeMode.dark,
                onChanged: (v) =>
                    setState(() => themeMode = v ? ThemeMode.dark : ThemeMode.light),
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between light and dark'),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Target per session'),
                subtitle: Text('Current: $target'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _editTarget,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionHeader(context, 'Widget'),
          _card(
            context,
            children: [
              ListTile(
                title: const Text('Default Dhikr'),
                subtitle: const Text('Select a default Dhikr for the widget'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(defaultDhikr),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: _pickDefaultDhikr,
              ),
            ],
          ),
        ],
      ),
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
      ),
      child: Column(children: children),
    );
  }

  Widget _sectionHeader(BuildContext context, String text) {
    final color = Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
    );
  }

  Future<void> _editTarget() async {
    final controller = TextEditingController(text: target.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Target'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g. 100'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              if (v != null && v > 0) Navigator.pop<int>(context, v);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) setState(() => target = result);
  }

  Future<void> _pickDefaultDhikr() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final t = _dhikrOptions[index];
              return ListTile(
                title: Text(t),
                trailing: defaultDhikr == t ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, t),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: _dhikrOptions.length,
          ),
        );
      },
    );
    if (result != null) setState(() => defaultDhikr = result);
  }
}
