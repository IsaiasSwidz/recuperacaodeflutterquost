import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../models/preferences.dart';
import 'preferences_screen.dart';
import 'history_screen.dart';

/// Tela de Dashboard - Ponto central do sistema de monitoramento
/// 
/// Esta tela permite ao usuário visualizar o estado atual do sistema,
/// acionar o botão de pânico, visualizar o status da API e configurar
/// as preferências de notificação
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _systemActive = false;
  bool _apiLoading = false;
  Map<String, dynamic>? _apiData;
  String _apiError = '';

  @override
  void initState() {
    super.initState();
    _fetchApiData();
  }

  /// Busca dados da API para demonstrar a integração
  Future<void> _fetchApiData() async {
    setState(() {
      _apiLoading = true;
      _apiError = '';
    });

    try {
      final data = await ApiService.fetchUser(1);
      if (data != null) {
        setState(() {
          _apiData = data;
          _apiLoading = false;
        });
      } else {
        setState(() {
          _apiError = 'Falha ao carregar dados da API';
          _apiLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _apiError = 'Erro: $e';
        _apiLoading = false;
      });
    }
  }

  /// Simula o disparo de um alerta/panico
  /// 
  /// Esta função registra o evento no banco de dados e envia uma notificação
  /// com base nas preferências do usuário
  Future<void> _simulateAlert() async {
    final prefs = context.read<PreferencesService>().preferences;
    final dbService = context.read<DatabaseService>();
    
    // Cria registro do evento
    final event = Event(
      type: 'ALERT',
      timestamp: DateTime.now(),
      description: 'Simulated panic button alert',
    );
    
    await dbService.insertEvent(event);
    
    // Mostra notificação com base nas preferências
    if (prefs.criticalMode) {
      await NotificationService.showCriticalNotification(
        title: 'CRITICAL ALERT',
        body: 'Panic button pressed! Emergency assistance required.',
        payload: 'alert_event',
      );
    } else {
      await NotificationService.showNotification(
        title: 'ALERT',
        body: 'Alert triggered from monitoring app',
        payload: 'alert_event',
      );
    }
    
    // Mostra feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alerta disparado com sucesso!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferencesService>().preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _systemActive ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _systemActive ? 'ACTIVE' : 'INACTIVE',
                          style: TextStyle(
                            color: _systemActive ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('System Active'),
                      value: _systemActive,
                      onChanged: (value) {
                        setState(() {
                          _systemActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Integration Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_apiLoading)
                      const LinearProgressIndicator()
                    else if (_apiError.isNotEmpty)
                      Text(
                        _apiError,
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (_apiData != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User: ${_apiData!['name']}'),
                          Text('Email: ${_apiData!['email']}'),
                          Text('Phone: ${_apiData!['phone']}'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _fetchApiData,
                            child: const Text('Refresh API Data'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Vibration'),
                      trailing: Switch(
                        value: prefs.vibrationEnabled,
                        onChanged: (value) => 
                          context.read<PreferencesService>().toggleVibration(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Sound'),
                      trailing: Switch(
                        value: prefs.soundEnabled,
                        onChanged: (value) => 
                          context.read<PreferencesService>().toggleSound(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Banner'),
                      trailing: Switch(
                        value: prefs.bannerEnabled,
                        onChanged: (value) => 
                          context.read<PreferencesService>().toggleBanner(),
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Critical Mode'),
                      subtitle: const Text('Force alerts even in silent mode'),
                      value: prefs.criticalMode,
                      onChanged: (value) => 
                        context.read<PreferencesService>().toggleCriticalMode(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'SIMULATE ALERT / PANIC BUTTON',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}