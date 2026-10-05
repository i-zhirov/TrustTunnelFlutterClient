import 'package:trusttunnel/common/controller/concurrency/sequential_controller_handler.dart';
import 'package:trusttunnel/common/controller/controller/state_controller.dart';
import 'package:trusttunnel/common/error/exception_utils.dart';
import 'package:trusttunnel/data/model/socks_settings.dart';
import 'package:trusttunnel/data/repository/socks_settings_repository.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/controller/socks_proxy_state.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@template socks_proxy_controller}
/// Controller for the SOCKS5 proxy settings screen.
///
/// Reads and persists the [SocksSettings] via the [SocksSettingsRepository].
/// {@endtemplate}
final class SocksProxyController extends BaseStateController<SocksProxyState> with SequentialControllerHandler {
  final SocksSettingsRepository _repository;

  /// {@macro socks_proxy_controller}
  SocksProxyController({
    required SocksSettingsRepository repository,
    super.initialState = const SocksProxyState.initial(),
  }) : _repository = repository;

  /// Loads the current settings.
  void fetch() => handle(
    () async {
      setState(
        SocksProxyState.loading(settings: state.settings),
      );

      setState(
        SocksProxyState.idle(settings: await _repository.getSettings()),
      );
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  /// Persists the active listener mode.
  void setMode(ListenerMode mode) => _persist(
    () => _repository.setMode(mode),
  );

  /// Persists the SOCKS proxy bind port.
  void setPort(int port) => _persist(
    () => _repository.setPort(port),
  );

  /// Persists the SOCKS proxy bind address (host).
  void setHost(String host) => _persist(
    () => _repository.setHost(host),
  );

  /// Persists the SOCKS proxy authentication username.
  void setUsername(String username) => _persist(
    () => _repository.setUsername(username),
  );

  /// Persists the SOCKS proxy authentication password.
  void setPassword(String password) => _persist(
    () => _repository.setPassword(password),
  );

  void _persist(Future<void> Function() mutation) => handle(
    () async {
      await mutation();

      setState(
        SocksProxyState.idle(settings: await _repository.getSettings()),
      );
    },
    errorHandler: _onError,
    completionHandler: _onCompleted,
  );

  void _onError(Object? error, StackTrace? stackTrace) => setState(
    SocksProxyState.error(
      settings: state.settings,
      error: ExceptionUtils.toPresentationException(exception: error),
    ),
  );

  void _onCompleted() => setState(
    SocksProxyState.idle(settings: state.settings),
  );
}
