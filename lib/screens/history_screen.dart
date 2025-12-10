/// Tela de Histórico - Exibe todos os eventos registrados
/// 
/// Esta tela lista todos os eventos disparados, contendo data, hora, 
/// tipo do evento e descrição. Os dados são armazenados localmente 
/// no SQLite e podem ser acessados offline.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/event.dart';

/// Tela que exibe o histórico de eventos
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Carrega todos os eventos do banco de dados
  Future<void> _loadEvents() async {
    await context.read<DatabaseService>().getAllEvents();
  }

  /// Formata a data e hora para exibição
  /// 
  /// Converte o objeto DateTime para o formato DD/MM/AAAA HH:MM
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
              await context.read<DatabaseService>().clearAllEvents();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todos os eventos foram limpos')),
              );
            },
          ),
        ],
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          return FutureBuilder<List<Event>>(
            future: dbService.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum evento registrado ainda',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final events = snapshot.data!;

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: event.type == 'ALERT' ? Colors.red.shade100 : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          event.type == 'ALERT' 
                              ? Icons.warning_amber_rounded 
                              : Icons.info_rounded,
                          color: event.type == 'ALERT' ? Colors.red : Colors.blue,
                        ),
                      ),
                      title: Text(
                        event.type,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.description ?? ''),
                          const SizedBox(height: 4),
                          Text(
                            _formatDateTime(event.timestamp),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}