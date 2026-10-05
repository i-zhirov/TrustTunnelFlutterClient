import 'package:shared_preferences/shared_preferences.dart';
import 'package:trusttunnel/data/datasources/socks_settings_datasource.dart';
import 'package:trusttunnel/data/model/socks_settings.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@category Data}
/// {@subCategory DataSource}
///
/// [SharedPreferences]-backed implementation of [SocksSettingsDataSource].
class SocksSettingsDataSourceImpl implements SocksSettingsDataSource {
  static const _modeKey = 'listener_mode';
  static const _portKey = 'socks_proxy_port';
  static const _hostKey = 'socks_proxy_host';
  static const _usernameKey = 'socks_proxy_username';
  static const _passwordKey = 'socks_proxy_password';

  static const _defaultPort = 1080;
  static const _minPort = 1;
  static const _maxPort = 65535;
  static const _defaultHost = '127.0.0.1';

  final SharedPreferences _preferences;

  SocksSettingsDataSourceImpl({
    required SharedPreferences preferences,
  }) : _preferences = preferences;

  @override
  Future<SocksSettings> getSettings() async => SocksSettings(
    mode: _readMode(),
    port: _readPort(),
    host: _preferences.getString(_hostKey) ?? _defaultHost,
    username: _preferences.getString(_usernameKey) ?? '',
    password: _preferences.getString(_passwordKey) ?? '',
  );

  ListenerMode _readMode() {
    final String? rawMode = _preferences.getString(_modeKey);

    return ListenerMode.values.firstWhere(
      (mode) => mode.value == rawMode,
      orElse: () => ListenerMode.tun,
    );
  }

  int _readPort() => _normalizePort(_preferences.getInt(_portKey) ?? _defaultPort);

  static int _normalizePort(int port) {
    if (port < _minPort) return _minPort;
    if (port > _maxPort) return _maxPort;

    return port;
  }

  @override
  Future<void> setMode(ListenerMode mode) => _preferences.setString(_modeKey, mode.value);

  @override
  Future<void> setPort(int port) => _preferences.setInt(_portKey, _normalizePort(port));

  @override
  Future<void> setHost(String host) => _preferences.setString(_hostKey, host);

  @override
  Future<void> setUsername(String username) => _preferences.setString(_usernameKey, username);

  @override
  Future<void> setPassword(String password) => _preferences.setString(_passwordKey, password);
}
