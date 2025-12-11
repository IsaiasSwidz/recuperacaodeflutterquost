import 'package:flutter/material.dart';
import 'package:projetorecuperacaomatheusquost/services/api/api_service.dart';
import 'package:provider/provider.dart';
import '../../services/notification_service.dart';
import '../../services/database_service.dart' hide DatabaseService;
import '../../services/preferences_service.dart';
import '../../services/api_service.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/preferences_model.dart';
import 'preferences_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _systemActive = true;
  bool _apiLoading = false;
  Map<String, dynamic>? _apiData;
  String _apiError = '';

  @override
  void initState() {
    super.initState();
    _fetchApiData();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await NotificationService().initialize();
  }

  Future<void> _fetchApiData() async {
    setState(() {
      _apiLoading = true;
      _apiError = '';
    });

    try {
      final apiService = ApiService();
      final data = await apiService.fetchSystemStatus();
      
      setState(() {
        _apiData = data;
        _apiLoading = false;
      });
    } catch (e) {
      setState(() {
        _apiError = 'Erro: $e';
        _apiLoading = false;
      });
    }
  }

  Future<void> _simulateAlert() async {
    try {
      final prefs = context.read<PreferencesService>().preferences;
      final dbService = DatabaseService();
      
      // Criar alerta
      final alert = AlertModel(
        type: 'ALERTE DE PÂNICO',
        triggerTime: DateTime.now(),
        isCritical: prefs.criticalMode, description: '',
      );
      
      // Salvar no banco
      await dbService.insertAlert(alert);
      
      // Enviar para API (opcional)
      try {
        await ApiService().sendAlert('Panic Button Pressed');
      } catch (e) {
        print('API offline: $e');
      }
      
      // Mostrar notificação
      await NotificationService().showAlertNotification(
        title: prefs.criticalMode ? 'ALERTA CRÍTICO!' : 'Alerta Disparado',
        body: 'Botão de pânico acionado - ${DateTime.now().toString()}',
        sound: prefs.soundEnabled,
        vibration: prefs.vibrationEnabled,
        critical: prefs.criticalMode,
      );
      
      // Feedback visual
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Alerta disparado com sucesso!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Ver Histórico',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao disparar alerta: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferencesService>().preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Monitoramento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PreferencesScreen()),
            ),
            tooltip: 'Configurações',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
            tooltip: 'Histórico',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status do Sistema
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status do Sistema',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          _systemActive ? Icons.check_circle : Icons.error,
                          color: _systemActive ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _systemActive ? 'SISTEMA ATIVO' : 'SISTEMA INATIVO',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _systemActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Ativar/Desativar Sistema'),
                      subtitle: const Text('Controla todo o monitoramento'),
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
            
            const SizedBox(height: 20),
            
            // Integração com API
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status da API',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_apiLoading)
                      const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Conectando à API...'),
                          ],
                        ),
                      )
                    else if (_apiError.isNotEmpty)
                      Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            _apiError,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else if (_apiData != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'API Conectada com Sucesso',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Dados recebidos: ${_apiData!['title'] ?? 'Teste'}'),
                          Text('Status: ${_apiData!['completed'] == true ? 'Concluído' : 'Pendente'}'),
                        ],
                      )
                    else
                      const Column(
                        children: [
                          Icon(Icons.cloud_off, color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text('API não conectada'),
                        ],
                      ),
                    
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _fetchApiData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Testar Conexão com API'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botão de Pânico
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ações de Emergência',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Use este botão em situações críticas para acionar alertas imediatamente.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _simulateAlert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.warning),
                      label: const Text(
                        'BOTÃO DE PÂNICO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Configurações Rápidas
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configurações Rápidas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Modo Crítico'),
                      subtitle: const Text('Alertas mesmo em modo silencioso'),
                      value: prefs.criticalMode,
                      onChanged: (value) => 
                        context.read<PreferencesService>().toggleCriticalMode(),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                prefs.vibrationEnabled ? Icons.vibration : Icons.vibration_off,
                                color: prefs.vibrationEnabled ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => 
                                context.read<PreferencesService>().toggleVibration(),
                            ),
                            const Text('Vibração'),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                prefs.soundEnabled ? Icons.volume_up : Icons.volume_off,
                                color: prefs.soundEnabled ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => 
                                context.read<PreferencesService>().toggleSound(),
                            ),
                            const Text('Som'),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                prefs.bannerEnabled ? Icons.notifications_active : Icons.notifications_off,
                                color: prefs.bannerEnabled ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => 
                                context.read<PreferencesService>().toggleBanner(),
                            ),
                            const Text('Notificação'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}