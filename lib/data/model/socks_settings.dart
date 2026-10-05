import 'package:vpn_plugin/models/listener_mode.dart';

/// {@template socks_settings}
/// App-level settings for the SOCKS5 proxy listener.
///
/// [mode] defines which listener is active at a time — either
/// [ListenerMode.tun] or [ListenerMode.socks]. When SOCKS mode is active, the
/// backend exposes a local SOCKS5 proxy bound to [address] with optional
/// [username]/[password] authentication.
/// {@endtemplate}
final class SocksSettings {
  /// {@template socks_settings_mode}
  /// Active traffic listener mode.
  /// {@endtemplate}
  final ListenerMode mode;

  /// {@template socks_settings_port}
  /// Port the local SOCKS5 proxy binds to.
  ///
  /// Must be in the range 1–65535; values outside are clamped to the range.
  /// {@endtemplate}
  final int port;

  /// {@template socks_settings_host}
  /// Address the local SOCKS5 proxy binds to.
  ///
  /// Defaults to the loopback interface (`127.0.0.1`). Use `0.0.0.0` to listen
  /// on all interfaces and allow connections from the local network.
  /// {@endtemplate}
  final String host;

  /// {@template socks_settings_username}
  /// Optional username for SOCKS5 authentication.
  /// {@endtemplate}
  final String username;

  /// {@template socks_settings_password}
  /// Optional password for SOCKS5 authentication.
  /// {@endtemplate}
  final String password;

  /// {@macro socks_settings}
  ///
  /// Defaults to [ListenerMode.tun] with the SOCKS listener on
  /// `127.0.0.1:1080` without authentication.
  const SocksSettings({
    this.mode = ListenerMode.tun,
    this.port = 1080,
    this.host = '127.0.0.1',
    this.username = '',
    this.password = '',
  });

  /// {@template socks_settings_address}
  /// Bind address of the local SOCKS5 proxy: `<host>:<port>`.
  ///
  /// By default the listener is bound to the loopback interface to avoid
  /// exposing the proxy to the local network. Set [host] to `0.0.0.0` to allow
  /// connections from other devices.
  /// {@endtemplate}
  String get address => '$host:$port';

  @override
  String toString() => 'SocksSettings(mode: $mode, port: $port, host: $host, username: $username, password: $password)';

  @override
  bool operator ==(covariant SocksSettings other) {
    if (identical(this, other)) return true;

    return other.mode == mode &&
        other.port == port &&
        other.host == host &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hashAll([
    mode,
    port,
    host,
    username,
    password,
  ]);
}
