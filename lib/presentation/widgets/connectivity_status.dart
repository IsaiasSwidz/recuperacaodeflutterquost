import 'package:flutter/material.dart';

class ConnectivityStatusWidget extends StatefulWidget {
  @override
  _ConnectivityStatusWidgetState createState() => 
      _ConnectivityStatusWidgetState();
}

class _ConnectivityStatusWidgetState extends State<ConnectivityStatusWidget> {
  bool _isConnected = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              _isConnected ? 'Conectado' : 'Desconectado',
              style: TextStyle(
                color: _isConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}