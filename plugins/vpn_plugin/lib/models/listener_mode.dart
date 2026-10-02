/// {@template listener_mode}
/// The active traffic listener mode.
///
/// The backend uses exactly one listener at a time:
/// - [tun] creates a virtual network interface and routes matching traffic
///   into the VPN tunnel,
/// - [socks] exposes a local SOCKS5 proxy (with UDP support) instead.
///
/// Only one mode should be active at a time; the configuration encoder emits
/// only the section corresponding to the active mode.
/// {@endtemplate}
enum ListenerMode {
  /// Run the backend in TUN device mode (default).
  tun('tun'),

  /// Run the backend in local SOCKS5 proxy mode.
  socks('socks');

  /// {@template listener_mode_value}
  /// Backend string representation of the mode.
  /// {@endtemplate}
  final String value;

  /// {@macro listener_mode}
  const ListenerMode(this.value);
}
