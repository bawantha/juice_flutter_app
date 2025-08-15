import 'package:flutter/material.dart';
import 'audio_service.dart';

void main() {
  runApp(const JuceAudioApp());
}

class JuceAudioApp extends StatelessWidget {
  const JuceAudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JUCE Flutter Audio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AudioControllerPage(),
    );
  }
}

class AudioControllerPage extends StatefulWidget {
  const AudioControllerPage({super.key});

  @override
  State<AudioControllerPage> createState() => _AudioControllerPageState();
}

class _AudioControllerPageState extends State<AudioControllerPage>
    with TickerProviderStateMixin {
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _volume = 0.5;
  double _frequency = 440.0;
  String _statusMessage = 'Ready to initialize';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (_isInitialized) {
      AudioService.release();
    }
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    setState(() {
      _statusMessage = 'Initializing...';
    });

    final success = await AudioService.initialize();
    setState(() {
      _isInitialized = success;
      _statusMessage = success
          ? 'Audio initialized successfully'
          : 'Failed to initialize audio';
    });
  }

  Future<void> _togglePlayback() async {
    if (!_isInitialized) return;

    if (_isPlaying) {
      await AudioService.stop();
      _pulseController.stop();
      setState(() {
        _isPlaying = false;
        _statusMessage = 'Audio stopped';
      });
    } else {
      await AudioService.start();
      _pulseController.repeat(reverse: true);
      setState(() {
        _isPlaying = true;
        _statusMessage = 'Audio playing';
      });
    }
  }

  Future<void> _updateVolume(double volume) async {
    await AudioService.setVolume(volume);
    setState(() {
      _volume = volume;
    });
  }

  Future<void> _updateFrequency(double frequency) async {
    await AudioService.setFrequency(frequency);
    setState(() {
      _frequency = frequency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 20),
                const Text(
                  'JUCE Audio Controller',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                const Spacer(),

                // Main Control Panel
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Play/Stop Button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isPlaying ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: _isPlaying
                                      ? [
                                          const Color(0xFFEF4444),
                                          const Color(0xFFDC2626),
                                        ]
                                      : [
                                          const Color(0xFF10B981),
                                          const Color(0xFF059669),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (_isPlaying ? Colors.red : Colors.green)
                                            .withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: _isInitialized
                                      ? _togglePlayback
                                      : null,
                                  child: Icon(
                                    _isPlaying ? Icons.stop : Icons.play_arrow,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Volume Control
                      _buildSliderControl(
                        'Volume',
                        _volume,
                        0.0,
                        1.0,
                        (value) => _updateVolume(value),
                        '${(_volume * 100).toInt()}%',
                        Icons.volume_up,
                      ),

                      const SizedBox(height: 32),

                      // Frequency Control
                      _buildSliderControl(
                        'Frequency',
                        _frequency,
                        220.0,
                        880.0,
                        (value) => _updateFrequency(value),
                        '${_frequency.toInt()} Hz',
                        Icons.graphic_eq,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Initialize Button
                if (!_isInitialized)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _initializeAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Initialize Audio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderControl(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    String displayValue,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const Spacer(),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF6366F1),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: const Color(0xFF6366F1),
            overlayColor: const Color(0xFF6366F1).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: _isInitialized ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
