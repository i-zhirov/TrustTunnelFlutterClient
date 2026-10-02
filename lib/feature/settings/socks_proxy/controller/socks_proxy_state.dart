import 'package:trusttunnel/common/error/model/presentation_exception.dart';
import 'package:trusttunnel/data/model/socks_settings.dart';

/// {@template socks_proxy_state}
/// State of the SOCKS5 proxy settings controller.
/// {@endtemplate}
sealed class SocksProxyState {
  /// Current SOCKS proxy settings.
  final SocksSettings settings;

  /// {@macro socks_proxy_state}
  const SocksProxyState({
    required this.settings,
  });

  /// Initial state with default settings.
  const factory SocksProxyState.initial() = _SocksProxyInitialState;

  /// Idle state with loaded settings.
  const factory SocksProxyState.idle({
    required SocksSettings settings,
  }) = _SocksProxyIdleState;

  /// Loading state while settings are being read or persisted.
  const factory SocksProxyState.loading({
    required SocksSettings settings,
  }) = _SocksProxyLoadingState;

  /// Error state with the last known settings.
  const factory SocksProxyState.error({
    required SocksSettings settings,
    required PresentationException error,
  }) = _SocksProxyErrorState;

  /// Error of the state, if any.
  PresentationException? get error => switch (this) {
    _SocksProxyErrorState(:final error) => error,
    _ => null,
  };

  /// Whether settings are being read or persisted.
  bool get loading => this is _SocksProxyLoadingState;

  /// Whether this is the initial state.
  bool get initial => this is _SocksProxyInitialState;

  @override
  int get hashCode => Object.hash(
    settings,
    error,
    loading,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocksProxyState &&
          runtimeType == other.runtimeType &&
          settings == other.settings &&
          error == other.error &&
          loading == other.loading;

  @override
  String toString() => 'SocksProxyState(type: $runtimeType, settings: $settings, loading: $loading)';
}

final class _SocksProxyInitialState extends _SocksProxyIdleState {
  const _SocksProxyInitialState() : super(settings: const SocksSettings());
}

final class _SocksProxyIdleState extends SocksProxyState {
  const _SocksProxyIdleState({
    required super.settings,
  });
}

final class _SocksProxyLoadingState extends SocksProxyState {
  const _SocksProxyLoadingState({
    required super.settings,
  });
}

final class _SocksProxyErrorState extends SocksProxyState {
  @override
  final PresentationException error;

  const _SocksProxyErrorState({
    required super.settings,
    required this.error,
  });
}
