import 'package:vpn_plugin/models/listener_mode.dart';

/// {@template socks_proxy_scope_controller}
/// Controller exposed by the SOCKS proxy settings scope.
/// {@endtemplate}
abstract class SocksProxyScopeController {
  /// Whether settings are being read or persisted.
  abstract final bool loading;

  /// Active traffic listener mode.
  abstract final ListenerMode mode;

  /// Port the local SOCKS5 proxy binds to.
  abstract final int port;

  /// SOCKS proxy authentication username.
  abstract final String username;

  /// SOCKS proxy authentication password.
  abstract final String password;

  /// Persists the active listener mode.
  abstract final void Function(ListenerMode mode) setMode;

  /// Persists the SOCKS proxy bind port.
  abstract final void Function(int port) setPort;

  /// Persists the SOCKS proxy authentication username.
  abstract final void Function(String username) setUsername;

  /// Persists the SOCKS proxy authentication password.
  abstract final void Function(String password) setPassword;
}
