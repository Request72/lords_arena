import 'package:flutter/material.dart';
import 'package:lords_arena/core/services/orientation_service.dart';
import 'package:lords_arena/core/services/stats_service.dart';
import 'package:lords_arena/core/services/audio_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  bool _soundEffectsEnabled = true;
  bool _backgroundMusicEnabled = true;
  bool _vibrationEnabled = true;
  bool _audioOptimizationEnabled = true;
  bool _lowLatencyEnabled = false;
  double _soundVolume = 1.0;
  double _musicVolume = 1.0;
  String _vibrationIntensity = 'medium';

  @override
  void initState() {
    super.initState();
    _setLandscapeMode();
    _tabController = TabController(length: 4, vsync: this);
    _loadStats();
    _loadAudioSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _setLandscapeMode() async {
    await OrientationService.setLandscapeMode();
  }

  Future<void> _loadStats() async {
    final stats = await StatsService.getStats();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  Future<void> _loadAudioSettings() async {
    final soundEffects = await AudioService.isSoundEffectsEnabled();
    final backgroundMusic = await AudioService.isBackgroundMusicEnabled();
    final vibration = await AudioService.isVibrationEnabled();
    final audioOptimization = await AudioService.isAudioOptimizationEnabled();
    final lowLatency = await AudioService.isLowLatencyEnabled();
    final soundVolume = await AudioService.getSoundVolume();
    final musicVolume = await AudioService.getMusicVolume();
    final vibrationIntensity = await AudioService.getVibrationIntensity();

    setState(() {
      _soundEffectsEnabled = soundEffects;
      _backgroundMusicEnabled = backgroundMusic;
      _vibrationEnabled = vibration;
      _audioOptimizationEnabled = audioOptimization;
      _lowLatencyEnabled = lowLatency;
      _soundVolume = soundVolume;
      _musicVolume = musicVolume;
      _vibrationIntensity = vibrationIntensity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      appBar: AppBar(
        title: const Text('Statistics', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Achievements'),
            Tab(text: 'Leaderboard'),
            Tab(text: 'Audio'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.75)),
          TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildAchievementsTab(),
              _buildLeaderboardTab(),
              _buildAudioTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            'Total Games Played',
            '${_stats['gamesPlayed'] ?? 0}',
            Icons.sports_esports,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Games Won',
            '${_stats['gamesWon'] ?? 0}',
            Icons.emoji_events,
            Colors.amber,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Win Rate',
            '${_stats['winRate'] ?? 0}%',
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Total Kills',
            '${_stats['totalKills'] ?? 0}',
            Icons.gps_fixed,
            Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Performance',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPerformanceChart(),
          const SizedBox(height: 20),
          const Text(
            'Weapon Stats',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildWeaponStats(),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    final achievements = _stats['achievements'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildAchievementCard(
            'First Blood',
            'Get your first kill',
            Icons.favorite,
            Colors.red,
            achievements.contains('first_blood'),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Sharpshooter',
            'Hit 10 enemies in a row',
            Icons.gps_fixed,
            Colors.amber,
            achievements.contains('sharpshooter'),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Survivor',
            'Win 5 games in a row',
            Icons.shield,
            Colors.blue,
            achievements.contains('survivor'),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Legend',
            'Win 100 games',
            Icons.star,
            Colors.purple,
            achievements.contains('legend'),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Unstoppable',
            'Win 10 games without dying',
            Icons.flash_on,
            Colors.orange,
            achievements.contains('unstoppable'),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Master',
            'Use all weapon types',
            Icons.sports_martial_arts,
            Colors.green,
            achievements.contains('master'),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildLeaderboardCard('Global', [
            _buildLeaderboardItem('Player1', '1,247 kills', 1, Colors.amber),
            _buildLeaderboardItem('Player2', '1,156 kills', 2, Colors.grey),
            _buildLeaderboardItem('Player3', '1,089 kills', 3, Colors.orange),
            _buildLeaderboardItem('Player4', '987 kills', 4, Colors.white),
            _buildLeaderboardItem('Player5', '876 kills', 5, Colors.white),
          ]),
          const SizedBox(height: 20),
          _buildLeaderboardCard('This Week', [
            _buildLeaderboardItem('Player1', '156 kills', 1, Colors.amber),
            _buildLeaderboardItem('Player2', '142 kills', 2, Colors.grey),
            _buildLeaderboardItem('Player3', '128 kills', 3, Colors.orange),
            _buildLeaderboardItem('Player4', '115 kills', 4, Colors.white),
            _buildLeaderboardItem('Player5', '98 kills', 5, Colors.white),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 7 Days',
            style: TextStyle(color: Colors.amber, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.8, 'Mon'),
                _buildBar(0.6, 'Tue'),
                _buildBar(0.9, 'Wed'),
                _buildBar(0.7, 'Thu'),
                _buildBar(0.8, 'Fri'),
                _buildBar(0.9, 'Sat'),
                _buildBar(0.7, 'Sun'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 100 * height,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildWeaponStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildWeaponStat('Rifle', '45%', 0.45),
          const SizedBox(height: 12),
          _buildWeaponStat('Shotgun', '30%', 0.30),
          const SizedBox(height: 12),
          _buildWeaponStat('Sniper', '25%', 0.25),
        ],
      ),
    );
  }

  Widget _buildWeaponStat(String weapon, String percentage, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              weapon,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              percentage,
              style: const TextStyle(color: Colors.amber, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool unlocked,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            unlocked
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              unlocked ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  unlocked
                      ? color.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              unlocked ? icon : Icons.lock,
              color: unlocked ? color : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: unlocked ? Colors.white70 : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(String title, List<Widget> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(
    String name,
    String score,
    int rank,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            '$rank',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Text(
        score,
        style: const TextStyle(color: Colors.amber, fontSize: 14),
      ),
    );
  }

  Widget _buildAudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAudioSection('Sound Effects', [
            _buildSwitchTile('Enable Sound Effects', _soundEffectsEnabled, (
              value,
            ) async {
              await AudioService.setSoundEffectsEnabled(value);
              setState(() => _soundEffectsEnabled = value);
            }),
            _buildSliderTile('Sound Volume', _soundVolume, (value) async {
              await AudioService.setSoundVolume(value);
              setState(() => _soundVolume = value);
            }),
          ]),
          const SizedBox(height: 20),
          _buildAudioSection('Background Music', [
            _buildSwitchTile(
              'Enable Background Music',
              _backgroundMusicEnabled,
              (value) async {
                await AudioService.setBackgroundMusicEnabled(value);
                setState(() => _backgroundMusicEnabled = value);
              },
            ),
            _buildSliderTile('Music Volume', _musicVolume, (value) async {
              await AudioService.setMusicVolume(value);
              setState(() => _musicVolume = value);
            }),
          ]),
          const SizedBox(height: 20),
          _buildAudioSection('Vibration', [
            _buildSwitchTile('Enable Vibration', _vibrationEnabled, (
              value,
            ) async {
              await AudioService.setVibrationEnabled(value);
              setState(() => _vibrationEnabled = value);
            }),
            _buildDropdownTile(
              'Vibration Intensity',
              _vibrationIntensity,
              ['light', 'medium', 'heavy'],
              (value) async {
                await AudioService.setVibrationIntensity(value);
                setState(() => _vibrationIntensity = value);
              },
            ),
            _buildButtonTile('Test Vibration', Icons.vibration, () async {
              await AudioService.vibrate();
            }),
          ]),
          const SizedBox(height: 20),
          _buildAudioSection('Audio Optimization', [
            _buildSwitchTile('Audio Optimization', _audioOptimizationEnabled, (
              value,
            ) async {
              await AudioService.setAudioOptimizationEnabled(value);
              setState(() => _audioOptimizationEnabled = value);
            }),
            _buildSwitchTile('Low Latency Mode', _lowLatencyEnabled, (
              value,
            ) async {
              await AudioService.setLowLatencyEnabled(value);
              setState(() => _lowLatencyEnabled = value);
            }),
          ]),
          const SizedBox(height: 20),
          _buildAudioSection('Test Audio', [
            _buildButtonTile('Test Sound Effects', Icons.volume_up, () async {
              await AudioService.playSoundEffect('assets/audio/shoot.wav');
            }),
            _buildButtonTile(
              'Test Background Music',
              Icons.music_note,
              () async {
                await AudioService.playBackgroundMusic();
              },
            ),
            _buildButtonTile('Stop Background Music', Icons.stop, () async {
              await AudioService.stopBackgroundMusic();
            }),
            _buildButtonTile('Test All Settings', Icons.settings, () async {
              final results = await AudioService.testSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings Test: ${results.toString()}'),
                  backgroundColor: Colors.amber,
                ),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _buildAudioSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.amber,
            activeTrackColor: Colors.amber.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    double value,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(color: Colors.amber, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.amber,
            inactiveColor: Colors.grey.withOpacity(0.3),
            min: 0.0,
            max: 1.0,
            divisions: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          DropdownButton<String>(
            value: value,
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            underline: Container(height: 2, color: Colors.amber),
            items:
                options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option.toUpperCase()),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonTile(String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.black),
          label: Text(title, style: const TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
