import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late IO.Socket socket;
  final _streamController = StreamController<String>();

  String socketUrl() {
    return "http://10.199.10.231:4201";
  }

  @override
  void initState() {
    super.initState();

    // Connect to the Socket.IO server
    socket = IO.io(socketUrl(), <String, dynamic>{
      'transports': ['websocket'],
    });

    // Event listener for 'connect' event
    socket.on('connect', (_) {
      print('Connected to server');
    });

    // Listen for messages from the server
    socket.on('message', (data) {
      _streamController.add(data);
    });
  }

  @override
  void dispose() {
    socket.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String? _messageType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome',
              hintText: 'Digite seu nome de usuário',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _roomController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sala',
              hintText: 'Digite o nome da sala',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tipo',
            ),
            items: <String>['Texto', 'Imagem', 'Vídeo'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _messageType = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mensagem',
              hintText: 'Digite o conteúdo da mensagem',
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Implementar a lógica de envio do pedido aqui
                print('Nome: ${_nameController.text}');
                print('Sala: ${_roomController.text}');
                print('Tipo: $_messageType');
                print('Mensagem: ${_messageController.text}');
              },
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}
