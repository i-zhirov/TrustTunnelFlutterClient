import 'package:flutter/widgets.dart';
import 'package:trusttunnel/common/controller/widget/state_consumer.dart';
import 'package:trusttunnel/common/extensions/context_extensions.dart';
import 'package:trusttunnel/common/localization/localization.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/controller/socks_proxy_controller.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/controller/socks_proxy_state.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/widgets/scope/socks_proxy_scope_aspect.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/widgets/scope/socks_proxy_scope_controller.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@template socks_proxy_scope}
/// Provides the SOCKS proxy settings controller to the widget tree.
/// {@endtemplate}
class SocksProxyScope extends StatefulWidget {
  final Widget child;

  /// {@macro socks_proxy_scope}
  const SocksProxyScope({
    required this.child,
    super.key,
  });

  /// Get the controller from context.
  static SocksProxyScopeController controllerOf(
    BuildContext context, {
    bool listen = true,
    SocksProxyScopeAspect? aspect,
  }) => _InheritedSocksProxyScope.controllerOf(context, listen: listen, aspect: aspect);

  @override
  State<SocksProxyScope> createState() => _SocksProxyScopeState();
}

class _SocksProxyScopeState extends State<SocksProxyScope> {
  late final SocksProxyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SocksProxyController(
      repository: context.repositoryFactory.socksSettingsRepository,
    );
    _controller.addListener(_showErrorSnackBarIfNeeded);
    _controller.fetch();
  }

  @override
  Widget build(BuildContext context) => StateConsumer<SocksProxyController, SocksProxyState>(
    controller: _controller,
    builder: (context, state, _) => _InheritedSocksProxyScope(
      loading: state.loading,
      mode: state.settings.mode,
      port: state.settings.port,
      host: state.settings.host,
      username: state.settings.username,
      password: state.settings.password,
      setMode: _controller.setMode,
      setPort: _controller.setPort,
      setHost: _controller.setHost,
      setUsername: _controller.setUsername,
      setPassword: _controller.setPassword,
      child: widget.child,
    ),
  );

  /// Show an error snack bar if the settings failed to load or persist.
  void _showErrorSnackBarIfNeeded() {
    if (_controller.state.error == null) {
      return;
    }

    context.showInfoSnackBar(message: context.ln.somethingWentWrongSnackbar);
  }

  @override
  void dispose() {
    _controller.removeListener(_showErrorSnackBarIfNeeded);
    _controller.dispose();

    super.dispose();
  }
}

class _InheritedSocksProxyScope extends InheritedModel<SocksProxyScopeAspect>
    implements SocksProxyScopeController {
  const _InheritedSocksProxyScope({
    required super.child,
    required this.loading,
    required this.mode,
    required this.port,
    required this.host,
    required this.username,
    required this.password,
    required this.setMode,
    required this.setPort,
    required this.setHost,
    required this.setUsername,
    required this.setPassword,
  });

  @override
  final bool loading;

  @override
  final ListenerMode mode;

  @override
  final int port;

  @override
  final String host;

  @override
  final String username;

  @override
  final String password;

  @override
  final void Function(ListenerMode mode) setMode;

  @override
  final void Function(int port) setPort;

  @override
  final void Function(String host) setHost;

  @override
  final void Function(String username) setUsername;

  @override
  final void Function(String password) setPassword;

  @override
  bool updateShouldNotify(_InheritedSocksProxyScope oldWidget) =>
      loading != oldWidget.loading ||
      mode != oldWidget.mode ||
      port != oldWidget.port ||
      host != oldWidget.host ||
      username != oldWidget.username ||
      password != oldWidget.password ||
      setMode != oldWidget.setMode ||
      setPort != oldWidget.setPort ||
      setHost != oldWidget.setHost ||
      setUsername != oldWidget.setUsername ||
      setPassword != oldWidget.setPassword;

  @override
  bool updateShouldNotifyDependent(
    covariant _InheritedSocksProxyScope oldWidget,
    Set<SocksProxyScopeAspect> dependencies,
  ) {
    if (dependencies.isEmpty) return updateShouldNotify(oldWidget);

    bool hasAnyChanges = false;

    for (final aspect in dependencies) {
      hasAnyChanges |= switch (aspect) {
        SocksProxyScopeAspect.settings =>
          mode != oldWidget.mode ||
              port != oldWidget.port ||
              host != oldWidget.host ||
              username != oldWidget.username ||
              password != oldWidget.password,
        SocksProxyScopeAspect.loading => loading != oldWidget.loading,
      };

      if (hasAnyChanges) return true;
    }

    return false;
  }

  static _InheritedSocksProxyScope controllerOf(
    BuildContext context, {
    bool listen = true,
    SocksProxyScopeAspect? aspect,
  }) => _inheritFrom(context, listen: listen, aspect: aspect) ?? _notFoundInheritedWidgetOfExactType();

  static _InheritedSocksProxyScope? _inheritFrom(
    BuildContext context, {
    bool listen = true,
    SocksProxyScopeAspect? aspect,
  }) => (listen
      ? InheritedModel.inheritFrom<_InheritedSocksProxyScope>(
          context,
          aspect: aspect,
        )
      : context.getElementForInheritedWidgetOfExactType<_InheritedSocksProxyScope>()?.widget
            as _InheritedSocksProxyScope?);

  static Never _notFoundInheritedWidgetOfExactType<T extends InheritedModel<SocksProxyScopeAspect>>() =>
      throw ArgumentError(
        'Inherited widget out of scope and not found of $T exact type',
        'out_of_scope',
      );
}
