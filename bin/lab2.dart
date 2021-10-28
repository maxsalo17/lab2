import 'dart:io';
import 'dart:math';

import 'package:dart_snmp/dart_snmp.dart';
import 'package:logging/logging.dart' as logging;

void main(List<String> arguments) async {
  var router = '192.168.56.20';
  var tftpServer = '192.168.56.1';
  var output = 'config_${DateTime.now().millisecondsSinceEpoch}.txt';
  var target = InternetAddress(router);
  var session = await Snmp.createSession(target,
      community: 'private', logLevel: logging.Level.OFF);
  var randomNumber = Random().nextInt(999);
  var varbinds = [
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.2.$randomNumber'),
        VarbindType.Integer, 1),
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.3.$randomNumber'),
        VarbindType.Integer, 4),
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.4.$randomNumber'),
        VarbindType.Integer, 1),
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.5.$randomNumber'),
        VarbindType.IpAddress, tftpServer),
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.6.$randomNumber'),
        VarbindType.OctetString, output),
    Varbind(Oid.fromString('1.3.6.1.4.1.9.9.96.1.1.1.1.14.$randomNumber'),
        VarbindType.Integer, 1),
  ];
  for (var varbind in varbinds) {
    await session.set(varbind);
  }
}
