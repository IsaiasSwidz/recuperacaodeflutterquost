import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/monitoring_provider.dart';
import '../../data/models/alert_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MonitoringProvider>(context);
    final alerts = provider.alerts;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Eventos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => provider.loadAlerts(),
          ),
        ],
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Nenhum evento registrado',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return _buildAlertItem(alerts[index]);
              },
            ),
    );
  }
  
  Widget _buildAlertItem(AlertModel alert) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          alert.isCritical ? Icons.warning : Icons.notifications,
          color: alert.isCritical ? Colors.red : Colors.blue,
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
            Text('Disparado: ${_formatDateTime(alert.triggerTime)}'),
            if (alert.processedTime != null)
              Text('Processado: ${_formatDateTime(alert.processedTime!)}'),
          ],
        ),
        trailing: Chip(
          label: Text(
            alert.isCritical ? 'Crítico' : 'Normal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          backgroundColor: alert.isCritical ? Colors.red : Colors.green,
        ),
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }
}