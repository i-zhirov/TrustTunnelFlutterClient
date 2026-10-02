import 'package:flutter_test/flutter_test.dart';
import 'package:vpn_plugin/domain/configuration_codec.dart';
import 'package:vpn_plugin/models/configuration.dart';
import 'package:vpn_plugin/models/endpoint.dart';
import 'package:vpn_plugin/models/listener_mode.dart';
import 'package:vpn_plugin/models/socks.dart';
import 'package:vpn_plugin/models/tun.dart';
import 'package:vpn_plugin/models/upstream_protocol.dart';
import 'package:vpn_plugin/models/vpn_mode.dart';

void main() {
  const ConfigurationCodec codec = ConfigurationCodec();

  Configuration configuration({
    ListenerMode mode = ListenerMode.tun,
    Tun tun = const Tun(),
    Socks socks = const Socks(),
  }) => Configuration(
    listenerMode: mode,
    vpnMode: VpnMode.general,
    endpoint: const Endpoint(
      name: 'Test server',
      hostName: 'example.com',
      username: 'user',
      password: 'pass',
      upStreamProtocol: UpStreamProtocol.http2,
      hasIpv6: true,
    ),
    tun: tun,
    socks: socks,
  );

  group('ListenerMode defaults', () {
    test('Configuration defaults to TUN listener mode', () {
      final Configuration config = configuration();

      expect(config.listenerMode, ListenerMode.tun);
    });

    test('Socks defaults to localhost address with no credentials', () {
      const Socks socks = Socks();

      expect(socks.address, '127.0.0.1:1080');
      expect(socks.username, '');
      expect(socks.password, '');
    });
  });

  group('ConfigurationEncoder', () {
    test('emits [listener.tun] and no [listener.socks] for TUN mode', () {
      final String encoded = codec.encode(
        configuration(tun: const Tun(excludedRoutes: ['10.0.0.0/8'])),
      );

      expect(encoded, contains('[listener.tun]'));
      expect(encoded, contains('included_routes'));
      expect(encoded, contains('excluded_routes'));
      expect(encoded, contains('mtu_size'));
      expect(encoded, isNot(contains('[listener.socks]')));
    });

    test('emits [listener.socks] and no [listener.tun] for SOCKS mode', () {
      final String encoded = codec.encode(
        configuration(
          mode: ListenerMode.socks,
          socks: const Socks(
            address: '127.0.0.1:1081',
            username: 'proxy-user',
            password: 'proxy-pass',
          ),
        ),
      );

      expect(encoded, contains('[listener.socks]'));
      expect(encoded, contains('address = "127.0.0.1:1081"'));
      expect(encoded, contains('username = "proxy-user"'));
      expect(encoded, contains('password = "proxy-pass"'));
      expect(encoded, isNot(contains('[listener.tun]')));
    });
  });

  group('ConfigurationDecoder', () {
    test('infers TUN mode when only [listener.tun] is present', () {
      final Configuration config = codec.decode(
        codec.encode(configuration()),
      );

      expect(config.listenerMode, ListenerMode.tun);
    });

    test('infers SOCKS mode when only [listener.socks] is present', () {
      final Configuration config = codec.decode(
        codec.encode(
          configuration(
            mode: ListenerMode.socks,
            socks: const Socks(
              address: '127.0.0.1:1081',
              username: 'proxy-user',
              password: 'proxy-pass',
            ),
          ),
        ),
      );

      expect(config.listenerMode, ListenerMode.socks);
      expect(config.socks.address, '127.0.0.1:1081');
      expect(config.socks.username, 'proxy-user');
      expect(config.socks.password, 'proxy-pass');
    });

    test('defaults to TUN mode when no listener section is present', () {
      const String input = 'loglevel = "debug"\nvpn_mode = "general"\n[endpoint]\nhostname = "example.com"\n';

      final Configuration config = codec.decode(input);

      expect(config.listenerMode, ListenerMode.tun);
    });

    test('SOCKS listener takes precedence when both sections are present', () {
      const String input = '''
loglevel = "debug"
vpn_mode = "general"
[endpoint]
hostname = "example.com"
[listener]

[listener.tun]
included_routes = ["0.0.0.0/0"]
mtu_size = 1350

[listener.socks]
address = "127.0.0.1:1080"
username = "proxy-user"
password = "proxy-pass"
''';

      final Configuration config = codec.decode(input);

      expect(config.listenerMode, ListenerMode.socks);
      expect(config.socks.username, 'proxy-user');
    });
  });

  group('Round trip', () {
    test('round-trips a TUN configuration', () {
      const Configuration original = Configuration(
        vpnMode: VpnMode.selective,
        endpoint: Endpoint(
          name: 'Test server',
          hostName: 'example.com',
          username: 'user',
          password: 'pass',
          upStreamProtocol: UpStreamProtocol.http2,
          hasIpv6: false,
        ),
        tun: Tun(
          excludedRoutes: ['10.0.0.0/8'],
          mtuSize: 1400,
        ),
        socks: Socks(
          address: '127.0.0.1:9999',
          username: 'unused',
          password: 'unused',
        ),
      );

      final Configuration decoded = codec.decode(codec.encode(original));

      expect(decoded.listenerMode, ListenerMode.tun);
      expect(decoded.tun.excludedRoutes, ['10.0.0.0/8']);
      expect(decoded.tun.mtuSize, 1400);
    });

    test('round-trips a SOCKS configuration', () {
      const Configuration original = Configuration(
        listenerMode: ListenerMode.socks,
        vpnMode: VpnMode.general,
        endpoint: Endpoint(
          name: 'Test server',
          hostName: 'example.com',
          username: 'user',
          password: 'pass',
          upStreamProtocol: UpStreamProtocol.http2,
          hasIpv6: true,
        ),
        tun: Tun(
          excludedRoutes: ['10.0.0.0/8'],
        ),
        socks: Socks(
          username: 'proxy-user',
          password: 'proxy-pass',
        ),
      );

      final Configuration decoded = codec.decode(codec.encode(original));

      expect(decoded.listenerMode, ListenerMode.socks);
      expect(decoded.socks.address, '127.0.0.1:1080');
      expect(decoded.socks.username, 'proxy-user');
      expect(decoded.socks.password, 'proxy-pass');
    });
  });
}
