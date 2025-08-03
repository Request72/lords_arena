import 'package:flutter/material.dart';
import 'package:lords_arena/core/services/orientation_service.dart';
import 'package:lords_arena/core/services/stats_service.dart';
import 'package:lords_arena/core/services/audio_service.dart';
import 'package:lords_arena/features/user/data/repositories/user_repository.dart';
import 'package:lords_arena/core/service_locator/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  double _soundVolume = 0.8;
  double _musicVolume = 0.6;
  String _difficulty = 'Normal';
  String _controlScheme = 'Joystick';

  @override
  void initState() {
    super.initState();
    _setLandscapeMode();
    _loadAudioSettings();
  }

  Future<void> _loadAudioSettings() async {
    final soundEnabled = await AudioService.isSoundEffectsEnabled();
    final musicEnabled = await AudioService.isBackgroundMusicEnabled();
    final vibrationEnabled = await AudioService.isVibrationEnabled();
    final soundVolume = await AudioService.getSoundVolume();
    final musicVolume = await AudioService.getMusicVolume();

    setState(() {
      _soundEnabled = soundEnabled;
      _musicEnabled = musicEnabled;
      _vibrationEnabled = vibrationEnabled;
      _soundVolume = soundVolume;
      _musicVolume = musicVolume;
    });
  }

  Future<void> _setLandscapeMode() async {
    await OrientationService.setLandscapeMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/warzone.jpg', fit: BoxFit.cover),
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.75)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Game Settings',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection('Audio Settings', [
                  _buildSwitchTile('Sound Effects', _soundEnabled, (
                    value,
                  ) async {
                    setState(() => _soundEnabled = value);
                    await AudioService.setSoundEffectsEnabled(value);
                  }),
                  _buildSwitchTile('Background Music', _musicEnabled, (
                    value,
                  ) async {
                    setState(() => _musicEnabled = value);
                    await AudioService.setBackgroundMusicEnabled(value);
                  }),
                  _buildSwitchTile('Vibration', _vibrationEnabled, (
                    value,
                  ) async {
                    setState(() => _vibrationEnabled = value);
                    await AudioService.setVibrationEnabled(value);
                  }),
                  _buildSliderTile('Sound Volume', _soundVolume, (value) async {
                    setState(() => _soundVolume = value);
                    await AudioService.setSoundVolume(value);
                  }),
                  _buildSliderTile('Music Volume', _musicVolume, (value) async {
                    setState(() => _musicVolume = value);
                    await AudioService.setMusicVolume(value);
                  }),
                ]),
                const SizedBox(height: 20),
                _buildSection('Gameplay Settings', [
                  _buildDropdownTile(
                    'Difficulty',
                    _difficulty,
                    ['Easy', 'Normal', 'Hard', 'Extreme'],
                    (value) {
                      setState(() => _difficulty = value);
                    },
                  ),
                  _buildDropdownTile(
                    'Control Scheme',
                    _controlScheme,
                    ['Joystick', 'Touch', 'Hybrid'],
                    (value) {
                      setState(() => _controlScheme = value);
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSection('Account Settings', [
                  _buildButtonTile('Change Password', Icons.lock_outline, () {
                    // TODO: Implement password change
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change coming soon!'),
                      ),
                    );
                  }),
                  _buildButtonTile('Delete Account', Icons.delete_forever, () {
                    _showDeleteAccountDialog();
                  }),
                  _buildButtonTile('Reset Stats', Icons.refresh, () {
                    _showResetStatsDialog();
                  }),
                ]),
                const SizedBox(height: 20),
                _buildSection('About', [
                  _buildInfoTile('Version', '1.0.0'),
                  _buildInfoTile('Build', '2024.1.1'),
                  _buildButtonTile('Terms of Service', Icons.description, () {
                    // TODO: Show terms
                  }),
                  _buildButtonTile('Privacy Policy', Icons.privacy_tip, () {
                    // TODO: Show privacy policy
                  }),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.amber,
        activeTrackColor: Colors.amber.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    double value,
    Function(double) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Slider(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.amber,
        inactiveColor: Colors.grey,
        min: 0.0,
        max: 1.0,
        divisions: 10,
      ),
      trailing: Text(
        '${(value * 100).toInt()}%',
        style: const TextStyle(color: Colors.amber, fontSize: 14),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) onChanged(newValue);
        },
        dropdownColor: Colors.black,
        style: const TextStyle(color: Colors.white),
        underline: Container(),
        items:
            options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildButtonTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Text(
        value,
        style: const TextStyle(color: Colors.amber, fontSize: 14),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteAccount();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showResetStatsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Reset Statistics',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to reset all your game statistics? This action cannot be undone.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _resetStats();
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // Clear user data
      sl<UserRepository>().clearUserData();

      // Reset all stats
      await StatsService.resetStats();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetStats() async {
    try {
      await StatsService.resetStats();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statistics reset successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
