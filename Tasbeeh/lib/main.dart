import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'db.dart' as dbpkg; // for mode helpers if needed
import 'db.dart' show AppDb; // Database

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDb.instance.init();
  runApp(const DhikrCounterApp());
}

class DhikrCounterApp extends StatefulWidget {
  const DhikrCounterApp({super.key});
  @override
  State<DhikrCounterApp> createState() => _DhikrCounterAppState();
}

class _DhikrCounterAppState extends State<DhikrCounterApp> {
  ThemeMode themeMode = ThemeMode.system;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final s = await AppDb.instance.getSettings();
    setState(() {
      themeMode = _stringToMode((s['theme_mode'] as String?) ?? 'system');
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    return MaterialApp(
      title: 'Dhikr Counter',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: HomePage(
        onThemeChanged: (m) async {
          setState(() => themeMode = m);
          await _persistTheme(m);
        },
        themeMode: themeMode,
      ),
    );
  }

  Future<void> _persistTheme(ThemeMode m) async {
    final s = await AppDb.instance.getSettings();
    await AppDb.instance.saveSettings(
      haptics: (s['haptics'] as int? ?? 1) == 1,
      sound: (s['sound'] as int? ?? 0) == 1,
      target: (s['target'] as int? ?? 100),
      defaultDhikr: (s['default_dhikr'] as String? ?? 'SubhanAllah'),
      themeMode: _modeToString(m),
    );
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1173D4),
    background: Color(0xFFF6F7F8),
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F7F8),
  useMaterial3: true,
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1173D4),
    background: Color(0xFF101922),
    surface: Color(0xFF0F172A),
  ),
  scaffoldBackgroundColor: const Color(0xFF101922),
  useMaterial3: true,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onThemeChanged, required this.themeMode});
  final ValueChanged<ThemeMode> onThemeChanged;
  final ThemeMode themeMode;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  int target = 100;
  bool haptics = true;
  bool sound = false;
  String defaultDhikr = 'SubhanAllah';
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final s = await AppDb.instance.getSettings();
    setState(() {
      haptics = (s['haptics'] as int? ?? 1) == 1;
      sound = (s['sound'] as int? ?? 0) == 1;
      target = (s['target'] as int? ?? 100);
      defaultDhikr = (s['default_dhikr'] as String? ?? 'SubhanAllah');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Text('Dhikr Counter', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _openSettingsPage,
                    style: IconButton.styleFrom(backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _BannerCard(
                      title: defaultDhikr,
                      subtitle: 'Target: $target',
                      imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=1640&auto=format&fit=crop',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size.square(220),
                            painter: RingBackgroundPainter(
                              trackColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          CustomPaint(
                            size: const Size.square(220),
                            painter: RingProgressPainter(
                              progress: (count / target).clamp(0, 1).toDouble(),
                              color: cs.primary,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$count', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('/ $target', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CircleButton(
                          size: 72,
                          bg: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          fg: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF334155),
                          icon: Icons.remove,
                          onPressed: () => setState(() => count = math.max(0, count - 1)),
                        ),
                        const SizedBox(width: 14),
                        _CircleButton(
                          size: 92,
                          bg: cs.primary,
                          fg: Colors.white,
                          icon: Icons.add,
                          onPressed: () async {
                            setState(() => count = math.min(target, count + 1));
                            await AppDb.instance.incrementDhikrItem(defaultDhikr);
                            if (haptics && count >= target) {
                              await AppDb.instance.addSession(
                                title: defaultDhikr,
                                durationLabel: 'n/a',
                                timeRange: 'n/a',
                                count: count,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Target completed!'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(milliseconds: 900),
                                ));
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 14),
                        _CircleButton(
                          size: 72,
                          bg: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          fg: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF334155),
                          icon: Icons.vibration,
                          onPressed: () {
                            setState(() => haptics = !haptics);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(haptics ? 'Haptics enabled (placeholder)' : 'Haptics disabled'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 900),
                            ));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation (Settings/Stats removed)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0B1220) : Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Dhikr List'),
                    NavigationDestination(icon: Icon(Icons.history), label: 'History'),
                  ],
                  selectedIndex: _navIndex,
                  onDestinationSelected: (i) async {
                    setState(() => _navIndex = i);
                    if (i == 1) {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DhikrListPage()));
                      setState(() {}); // refresh after returning
                    } else if (i == 2) {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DhikrHistoryPage()));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettingsPage() async {
    final currentMode = widget.themeMode == ThemeMode.system
        ? (MediaQuery.of(context).platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
        : widget.themeMode;

    final result = await Navigator.of(context).push<SettingsData>(
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          initial: SettingsData(
            haptics: haptics,
            sound: sound,
            target: target,
            defaultDhikr: defaultDhikr,
            themeMode: currentMode,
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        haptics = result.haptics;
        sound = result.sound;
        target = result.target;
        defaultDhikr = result.defaultDhikr;
        count = count.clamp(0, target).toInt();
      });
      widget.onThemeChanged(result.themeMode);

      // persist all settings
      await AppDb.instance.saveSettings(
        haptics: haptics,
        sound: sound,
        target: target,
        defaultDhikr: defaultDhikr,
        themeMode: _modeToString(result.themeMode),
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Settings updated'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 900),
      ));
    }
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.size, required this.bg, required this.fg, required this.icon, required this.onPressed});
  final double size;
  final Color bg;
  final Color fg;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, color: fg, size: size * 0.45),
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.title, required this.subtitle, required this.imageUrl});
  final String title;
  final String subtitle;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
              Color.fromARGB(153, 0, 0, 0),
              Color.fromARGB(0, 0, 0, 0),
            ]),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class RingBackgroundPainter extends CustomPainter {
  RingBackgroundPainter({required this.trackColor});
  final Color trackColor;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    canvas.drawCircle(center, radius, track);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RingProgressPainter extends CustomPainter {
  RingProgressPainter({required this.progress, required this.color});
  final double progress; // 0..1
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint);
  }
  @override
  bool shouldRepaint(covariant RingProgressPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}

class DhikrListPage extends StatefulWidget {
  const DhikrListPage({super.key});
  @override
  State<DhikrListPage> createState() => _DhikrListPageState();
}

class _DhikrListPageState extends State<DhikrListPage> {
  List<_DhikrItem> items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await AppDb.instance.getDhikrItems();
    setState(() {
      items = rows
          .map((e) => _DhikrItem(name: (e['name'] as String), count: (e['count'] as int)))
          .toList();
      _loading = false;
    });
  }

  Future<void> _addNew() async {
    final name = 'New Dhikr ${items.length + 1}';
    await AppDb.instance.upsertDhikrItem(name, 0);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhikr List'),
        centerTitle: true,
        actions: [IconButton(onPressed: _addNew, icon: Icon(Icons.add, color: cs.primary))],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            final bg = Theme.of(context).brightness == Brightness.dark ? cs.primary.withOpacity(0.10) : Colors.white;
            return Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (Theme.of(context).brightness == Brightness.light)
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Current Count: ${item.count}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        )),
                  ]),
                  FilledButton(
                    onPressed: () async {
                      await AppDb.instance.incrementDhikrItem(item.name);
                      await _load();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text('+1'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Dhikr List'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
        selectedIndex: 1,
        onDestinationSelected: (i) {
          if (i == 0) Navigator.pop(context);
          if (i == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DhikrHistoryPage()));
          }
        },
      ),
    );
  }
}

class _DhikrItem {
  final String name;
  final int count;
  _DhikrItem({required this.name, required this.count});
}

class DhikrHistoryPage extends StatefulWidget {
  const DhikrHistoryPage({super.key});
  @override
  State<DhikrHistoryPage> createState() => _DhikrHistoryPageState();
}

class _DhikrHistoryPageState extends State<DhikrHistoryPage> {
  List<Map<String, Object?>> rows = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await AppDb.instance.getSessions();
    setState(() {
      rows = r;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        title: const Text('History'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final s = rows[i];
            final created = DateTime.fromMillisecondsSinceEpoch((s['created_at'] as int));
            final title = s['title'] as String;
            final count = s['count'] as int;
            final durationLabel = (s['duration_label'] as String?) ?? '—';
            final timeRange = (s['time_range'] as String?) ?? '—';
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bg = isDark ? const Color(0x8023344D) : const Color(0xFFF1F5F9);

            return Container(
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('$durationLabel  •  ${created.toLocal()}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          )),
                      Text(timeRange,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          )),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Text('$count',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Export tapped'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(milliseconds: 900),
                  ));
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colorScheme.primary.withOpacity(isDark ? 0.30 : 0.20),
                ),
                child: const Text('Export', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Sync tapped'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(milliseconds: 900),
                  ));
                },
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Sync', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _modeToString(ThemeMode m) =>
    m == ThemeMode.dark ? 'dark' : m == ThemeMode.light ? 'light' : 'system';
ThemeMode _stringToMode(String s) =>
    s == 'dark' ? ThemeMode.dark : s == 'light' ? ThemeMode.light : ThemeMode.system;
