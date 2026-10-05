import 'package:trusttunnel/data/datasources/socks_settings_datasource.dart';
import 'package:trusttunnel/data/model/socks_settings.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@category Data}
/// {@subCategory Repository}
///
/// Repository for the SOCKS5 proxy listener settings.
abstract class SocksSettingsRepository {
  /// Reads the current SOCKS proxy settings.
  Future<SocksSettings> getSettings();

  /// Persists the active listener mode.
  Future<void> setMode(ListenerMode mode);

  /// Persists the SOCKS proxy bind port.
  Future<void> setPort(int port);

  /// Persists the SOCKS proxy bind address (host).
  Future<void> setHost(String host);

  /// Persists the SOCKS proxy authentication username.
  Future<void> setUsername(String username);

  /// Persists the SOCKS proxy authentication password.
  Future<void> setPassword(String password);
}

/// {@category Data}
/// {@subCategory Repository}
///
/// Default [SocksSettingsRepository] implementation delegating to a
/// [SocksSettingsDataSource].
class SocksSettingsRepositoryImpl implements SocksSettingsRepository {
  final SocksSettingsDataSource _dataSource;

  SocksSettingsRepositoryImpl({
    required SocksSettingsDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<SocksSettings> getSettings() => _dataSource.getSettings();

  @override
  Future<void> setMode(ListenerMode mode) => _dataSource.setMode(mode);

  @override
  Future<void> setPort(int port) => _dataSource.setPort(port);

  @override
  Future<void> setHost(String host) => _dataSource.setHost(host);

  @override
  Future<void> setUsername(String username) => _dataSource.setUsername(username);

  @override
  Future<void> setPassword(String password) => _dataSource.setPassword(password);
}
