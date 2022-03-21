import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { onlline, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    // token
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });
    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.onlline;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('new-message', (payload) {
    //   print('message :$payload');
    //   print('message :' + payload['nombre']);
    //   print('message :' + payload['message']);
    //   print(
    //       payload.containsKey('message2') ? payload['message'] : 'no message2');
    // });

    // socket.on('fromServer', (_) => print(_));
  }

  void disconnect() {
    _socket.disconnect();
  }
}
