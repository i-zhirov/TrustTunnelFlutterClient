import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trusttunnel/common/assets/asset_icons.dart';
import 'package:trusttunnel/common/extensions/context_extensions.dart';
import 'package:trusttunnel/common/localization/localization.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/widgets/scope/socks_proxy_scope.dart';
import 'package:trusttunnel/feature/settings/socks_proxy/widgets/scope/socks_proxy_scope_controller.dart';
import 'package:trusttunnel/widgets/common/custom_radio_list_tile.dart';
import 'package:trusttunnel/widgets/custom_app_bar.dart';
import 'package:trusttunnel/widgets/inputs/custom_text_field.dart';
import 'package:trusttunnel/widgets/scaffold_wrapper.dart';
import 'package:vpn_plugin/models/listener_mode.dart';

/// {@template socks_proxy_screen}
/// Settings screen for the SOCKS5 proxy listener mode.
///
/// Allows switching between TUN and SOCKS5 proxy modes and configuring the
/// SOCKS5 proxy port, username and password.
/// {@endtemplate}
class SocksProxyScreen extends StatefulWidget {
  /// {@macro socks_proxy_screen}
  const SocksProxyScreen({super.key});

  @override
  State<SocksProxyScreen> createState() => _SocksProxyScreenState();
}

class _SocksProxyScreenState extends State<SocksProxyScreen> {
  late SocksProxyScopeController _controller;
  late ListenerMode _mode;
  late int _port;
  late String _username;
  late String _password;
  late final ValueNotifier<bool> _isPasswordVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _isPasswordVisibleNotifier = ValueNotifier<bool>(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = SocksProxyScope.controllerOf(context);
    _mode = _controller.mode;
    _port = _controller.port;
    _username = _controller.username;
    _password = _controller.password;
  }

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
    child: Scaffold(
      appBar: CustomAppBar(
        title: context.ln.socksProxySettings,
        centerTitle: true,
        leadingIconType: AppBarLeadingIconType.back,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.ln.connectionMode,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CustomRadioListTile<ListenerMode>(
            value: ListenerMode.tun,
            groupValue: _mode,
            onChanged: _setMode,
            title: context.ln.tunMode,
            subTitle: context.ln.tunModeDescription,
            radioColor: context.colors.neutralBlack,
          ),
          CustomRadioListTile<ListenerMode>(
            value: ListenerMode.socks,
            groupValue: _mode,
            onChanged: _setMode,
            title: context.ln.socksProxyMode,
            subTitle: context.ln.socksProxyModeDescription,
            radioColor: context.colors.neutralBlack,
          ),
          if (_mode == ListenerMode.socks) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.ln.proxyParameters,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                value: _port.toString(),
                label: context.ln.proxyPort,
                hint: context.ln.proxyPortHint,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onPortChanged,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                value: _username,
                label: context.ln.proxyUsername,
                hint: context.ln.enterUsername,
                onChanged: _controller.setUsername,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListenableBuilder(
                listenable: _isPasswordVisibleNotifier,
                builder: (context, _) => CustomTextField.customSuffixIcon(
                  value: _password,
                  label: context.ln.proxyPassword,
                  hint: context.ln.enterPassword,
                  obscureText: !_isPasswordVisibleNotifier.value,
                  onChanged: _controller.setPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisibleNotifier.value ? AssetIcons.eye : AssetIcons.eyeClosed,
                    ),
                    onPressed: () => _isPasswordVisibleNotifier.value = !_isPasswordVisibleNotifier.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    ),
  );

  void _setMode(ListenerMode? mode) {
    if (mode != null) {
      _controller.setMode(mode);
    }
  }

  void _onPortChanged(String value) {
    final int? port = int.tryParse(value);
    if (port == null) {
      return;
    }

    _controller.setPort(port);
  }

  @override
  void dispose() {
    _isPasswordVisibleNotifier.dispose();

    super.dispose();
  }
}
