import 'package:trusttunnel/data/model/socks_settings.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@category Data}
/// {@subCategory DataSource}
///
/// Persistence interface for the SOCKS5 proxy listener settings.
abstract class SocksSettingsDataSource {
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
