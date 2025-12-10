import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/monitoring_provider.dart';
import '../../services/api/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _apiData;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _fetchApiData();
  }
  
  Future<void> _fetchApiData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.fetchSystemStatus();
      setState(() => _apiData = data);
    } catch (e) {
      print('Error fetching API data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MonitoringProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard de Monitoramento'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status do Sistema
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Status do Sistema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          provider.isSystemActive
                              ? Icons.check_circle
                              : Icons.error,
                          color: provider.isSystemActive
                              ? Colors.green
                              : Colors.red,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          provider.isSystemActive ? 'ATIVADO' : 'DESATIVADO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: provider.isSystemActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Botão de Pânico
            ElevatedButton(
              onPressed: () => _triggerAlert(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'SIMULAR ALERTA / BOTÃO DE PÂNICO',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Dados da API
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status da API',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _apiData != null
                            ? Text(
                                'Dados recebidos: ${_apiData!['title'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 14),
                              )
                            : Text(
                                'Falha ao conectar com API',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                  ],
                ),
              ),
            ),
            
            // Espaço para WebSocket (opcional)
            // ConnectivityStatusWidget(),
          ],
        ),
      ),
    );
  }
  
  Future<void> _triggerAlert(BuildContext context) async {
    final provider = Provider.of<MonitoringProvider>(context, listen: false);
    await provider.triggerAlert('Panic Button');
    
    // Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alerta disparado!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}