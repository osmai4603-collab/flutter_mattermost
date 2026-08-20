import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class CallsSettingsPage extends StatefulWidget {
  const CallsSettingsPage({super.key});

  @override
  State<CallsSettingsPage> createState() => _CallsSettingsPageState();
}

class _CallsSettingsPageState extends State<CallsSettingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  bool _enablePlugin = false;
  bool _enableDefaultForChannel = false;
  bool _enableRecordings = false;
  bool _enableScreenSharing = false;
  bool _enableLiveCaptions = false;
  bool _enableRinging = false;
  final TextEditingController _rtcServerPortController =
      TextEditingController();
  final TextEditingController _maxCallDurationController =
      TextEditingController();
  final TextEditingController _idleTimeoutController = TextEditingController();
  final TextEditingController _stunUriController = TextEditingController();
  final TextEditingController _turnUriController = TextEditingController();
  final TextEditingController _turnUsernameController = TextEditingController();
  final TextEditingController _turnPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _rtcServerPortController.dispose();
    _maxCallDurationController.dispose();
    _idleTimeoutController.dispose();
    _stunUriController.dispose();
    _turnUriController.dispose();
    _turnUsernameController.dispose();
    _turnPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final pluginSettings =
          (config['PluginSettings'] as Map<String, dynamic>?) ?? const {};
      final pluginStates =
          (pluginSettings['PluginStates'] as Map<String, dynamic>?) ?? const {};
      final callsState =
          (pluginStates['com.mattermost.calls'] as Map<String, dynamic>?) ??
          const {};
      _enablePlugin = callsState['Enable'] == true;

      final plugins =
          (pluginSettings['Plugins'] as Map<String, dynamic>?) ?? const {};
      final callsConfig =
          (plugins['com.mattermost.calls'] as Map<String, dynamic>?) ??
          const {};
      _enableDefaultForChannel = callsConfig['DefaultEnabled'] == true;
      _enableRecordings = callsConfig['EnableRecordings'] == true;
      _enableScreenSharing = callsConfig['EnableScreenSharing'] == true;
      _enableLiveCaptions = callsConfig['EnableLiveCaptions'] == true;
      _enableRinging = callsConfig['EnableRinging'] == true;
      _rtcServerPortController.text =
          (callsConfig['RTCServerPort']?.toString()) ?? '8443';
      _maxCallDurationController.text =
          (callsConfig['MaxCallDuration']?.toString()) ?? '0';
      _idleTimeoutController.text =
          (callsConfig['IdleTimeout']?.toString()) ?? '300';

      final iceServers = (callsConfig['ICEServers'] as List<dynamic>?) ?? [];
      for (final server in iceServers) {
        final serverMap = server as Map<String, dynamic>?;
        if (serverMap != null) {
          final urls = (serverMap['urls'] as List<dynamic>?) ?? [];
          final url = urls.isNotEmpty ? urls.first.toString() : '';
          if (url.startsWith('stun:')) {
            _stunUriController.text = url;
          } else if (url.startsWith('turn:') || url.startsWith('turns:')) {
            _turnUriController.text = url;
            _turnUsernameController.text =
                (serverMap['username'] as String?) ?? '';
            _turnPasswordController.text =
                (serverMap['credential'] as String?) ?? '';
          }
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    final colors = AppTheme.of(context);
    setState(() => _isSaving = true);
    try {
      final iceservers = <Map<String, dynamic>>[];
      if (_stunUriController.text.trim().isNotEmpty) {
        iceservers.add({
          'urls': [_stunUriController.text.trim()],
        });
      }
      if (_turnUriController.text.trim().isNotEmpty) {
        iceservers.add({
          'urls': [_turnUriController.text.trim()],
          'username': _turnUsernameController.text.trim(),
          'credential': _turnPasswordController.text.trim(),
        });
      }

      final patch = {
        'PluginSettings': {
          'PluginStates': {
            'com.mattermost.calls': {'Enable': _enablePlugin},
          },
          'Plugins': {
            'com.mattermost.calls': {
              'DefaultEnabled': _enableDefaultForChannel,
              'EnableRecordings': _enableRecordings,
              'EnableScreenSharing': _enableScreenSharing,
              'EnableLiveCaptions': _enableLiveCaptions,
              'EnableRinging': _enableRinging,
              'RTCServerPort':
                  int.tryParse(_rtcServerPortController.text.trim()) ?? 8443,
              'MaxCallDuration':
                  int.tryParse(_maxCallDurationController.text.trim()) ?? 0,
              'IdleTimeout':
                  int.tryParse(_idleTimeoutController.text.trim()) ?? 300,
              'ICEServers': iceservers,
            },
          },
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        setState(() => _hasUnsavedChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Calls settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _markChanged() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Calls',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : Column(
              spacing: 24,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEnablePluginSection(colors),
                        const SizedBox(height: 20),
                        _buildCallSettingsSection(colors),
                        const SizedBox(height: 20),
                        _buildFeaturesSection(colors),
                        const SizedBox(height: 20),
                        _buildNetworkSection(colors),
                        const SizedBox(height: 20),
                        _buildICEServersSection(colors),
                      ],
                    ),
                  ),
                ),
                if (_hasUnsavedChanges) _buildSaveBar(colors),
              ],
            ),
    );
  }

  Widget _buildEnablePluginSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enablePlugin,
          onChanged: (v) {
            if (v != null) {
              setState(() => _enablePlugin = v);
              _markChanged();
            }
          },
          title: 'Enable Plugin',
          subtitle:
              'When true, enables the Mattermost Calls plugin. This provides voice and video calling capabilities within channels and direct messages.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableDefaultForChannel,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableDefaultForChannel = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Calls in Channels by Default',
          subtitle:
              'When true, calls are enabled by default in all channels. Channel admins can still disable calls on a per-channel basis.',
        ),
      ],
    );
  }

  Widget _buildCallSettingsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Call Settings',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure call duration limits and idle timeouts.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _textTile(
          colors,
          controller: _maxCallDurationController,
          title: 'Max Call Duration (seconds)',
          subtitle:
              'The maximum duration of a call in seconds. Set to 0 for unlimited. When the limit is reached, the call will be automatically ended.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _idleTimeoutController,
          title: 'Idle Timeout (seconds)',
          subtitle:
              'The number of seconds after which an empty call (no participants) is automatically ended. Set to 0 to disable.',
          placeholder: '300',
          keyboardType: TextInputType.number,
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _rtcServerPortController,
          title: 'RTC Server Port',
          subtitle:
              'The port used by the RTC server for WebRTC signaling. This port must be accessible from all client browsers.',
          placeholder: '8443',
          keyboardType: TextInputType.number,
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Features',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Enable or disable specific call features.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _boolTile(
          colors,
          value: _enableRecordings,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableRecordings = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Recordings',
          subtitle:
              'When true, allows participants to record calls. Recordings are stored on the server and can be downloaded or shared.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableScreenSharing,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableScreenSharing = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Screen Sharing',
          subtitle:
              'When true, allows participants to share their screen during calls. Supports full screen and application window sharing.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableLiveCaptions,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableLiveCaptions = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Live Captions',
          subtitle:
              'When true, enables real-time speech-to-text captions during calls. Requires additional AI service configuration.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableRinging,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableRinging = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Ringing',
          subtitle:
              'When true, enables call ringing notifications for direct message calls. Recipients receive an audible and visual notification.',
        ),
      ],
    );
  }

  Widget _buildNetworkSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Network Configuration',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure network settings for WebRTC connections. These settings are required for calls to work in production environments.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.buttonBg.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.buttonBg.withValues(alpha: 0.20)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colors.buttonBg, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'For production deployments, you must configure ICE servers (STUN/TURN) to allow calls through firewalls and NAT. Without proper ICE configuration, calls may fail for remote users.',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildICEServersSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'ICE Servers',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure STUN and TURN servers for WebRTC connectivity.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _textTile(
          colors,
          controller: _stunUriController,
          title: 'STUN Server URI',
          subtitle:
              'The URI of the STUN server used for NAT traversal. Example: stun:stun.example.com:3478',
          placeholder: 'stun:stun.example.com:3478',
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _turnUriController,
          title: 'TURN Server URI',
          subtitle:
              'The URI of the TURN server used as a relay when direct connection fails. Example: turn:turn.example.com:3478',
          placeholder: 'turn:turn.example.com:3478',
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        if (_turnUriController.text.trim().isNotEmpty) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _turnUsernameController,
            title: 'TURN Username',
            subtitle: 'Username for TURN server authentication.',
            placeholder: 'Username',
            enabled: _enablePlugin,
            onChanged: (_) => _markChanged(),
          ),
          _divider(colors),
          _textTile(
            colors,
            controller: _turnPasswordController,
            title: 'TURN Password',
            subtitle: 'Password for TURN server authentication.',
            placeholder: 'Password',
            enabled: _enablePlugin,
            onChanged: (_) => _markChanged(),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveBar(MattermostColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        border: Border(
          top: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.linkColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have unsaved changes',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: _isSaving
                ? null
                : () {
                    setState(() => _hasUnsavedChanges = false);
                    _loadConfig();
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colors.centerChannelColor.withValues(alpha: 0.24),
              ),
              foregroundColor: colors.buttonColor.withValues(alpha: 0.70),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _isSaving ? null : _saveConfig,
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
            icon: _isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.buttonColor,
                    ),
                  )
                : Icon(
                    Icons.save_outlined,
                    size: 16,
                    color: colors.buttonColor,
                  ),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    MattermostColors colors, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _divider(MattermostColors colors) {
    return Divider(
      color: colors.centerChannelColor.withValues(alpha: 0.10),
      height: 24,
    );
  }

  Widget _boolTile(
    MattermostColors colors, {
    required bool value,
    ValueChanged<bool?>? onChanged,
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.buttonBg,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          color: colors.centerChannelColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colors.centerChannelColor.withValues(alpha: 0.54),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _textTile(
    MattermostColors colors, {
    required TextEditingController controller,
    required String title,
    required String subtitle,
    String? placeholder,
    TextInputType? keyboardType,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          onChanged: onChanged,
          style: TextStyle(
            color: enabled
                ? colors.centerChannelColor
                : colors.centerChannelColor.withValues(alpha: 0.38),
            fontSize: 13,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.38),
              fontSize: 13,
            ),
            filled: true,
            fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
