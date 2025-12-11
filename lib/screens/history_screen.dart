import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/alert_model.dart'; // Use AlertModel em vez de Event

/// Tela de Histórico - Exibe todos os eventos registrados
/// 
/// Esta tela lista todos os eventos disparados, contendo data, hora, 
/// tipo do evento e descrição. Os dados são armazenados localmente 
/// no SQLite e podem ser acessados offline.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<AlertModel>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = _loadEvents();
  }

  /// Carrega todos os eventos do banco de dados
  Future<List<AlertModel>> _loadEvents() async {
    final dbService = DatabaseService();
    return await dbService.getAlerts(); // Método correto
  }

  /// Formata a data e hora para exibição
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Limpa todos os eventos do histórico
  Future<void> _clearAllEvents() async {
    final dbService = DatabaseService();
    await dbService.clearAlerts(); // Método correto
    setState(() {
      _alertsFuture = _loadEvents(); // Recarregar a lista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Alertas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await _clearAllEvents();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os eventos foram limpos'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _alertsFuture = _loadEvents();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AlertModel>>(
        future: _alertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _alertsFuture = _loadEvents();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum evento registrado ainda',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Os alertas disparados aparecerão aqui',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final alerts = snapshot.data!;

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: alert.isCritical 
                          ? Colors.red.shade100 
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      alert.isCritical ? Icons.warning : Icons.notifications,
                      color: alert.isCritical ? Colors.red : Colors.orange,
                    ),
                  ),
                  title: Text(
                    alert.type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: alert.isCritical ? Colors.red : Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Disparado: ${_formatDateTime(alert.triggerTime)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (alert.processedTime != null)
                        Text(
                          'Processado: ${_formatDateTime(alert.processedTime!)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      alert.isCritical ? 'CRÍTICO' : 'NORMAL',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: alert.isCritical ? Colors.red : Colors.blue,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}