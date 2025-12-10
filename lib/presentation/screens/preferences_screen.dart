import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/monitoring_provider.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MonitoringProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferências'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Tipos de Notificação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          SwitchListTile(
            title: Text('Vibração'),
            subtitle: Text('Ativar vibração nas notificações'),
            value: provider.preferences.vibrationEnabled,
            onChanged: (value) => provider.setVibrationEnabled(value),
          ),
          
          SwitchListTile(
            title: Text('Som'),
            subtitle: Text('Ativar som nas notificações'),
            value: provider.preferences.soundEnabled,
            onChanged: (value) => provider.setSoundEnabled(value),
          ),
          
          SwitchListTile(
            title: Text('Banner'),
            subtitle: Text('Mostrar banner de notificação'),
            value: provider.preferences.bannerEnabled,
            onChanged: (value) => provider.setBannerEnabled(value),
          ),
          
          Divider(height: 30),
          
          Text(
            'Modo Crítico',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          SwitchListTile(
            title: Text('Ativar Modo Crítico'),
            subtitle: Text(
              'Reproduz alertas mesmo em modo silencioso/Não Perturbe',
              style: TextStyle(color: Colors.red),
            ),
            value: provider.preferences.criticalMode,
            onChanged: (value) => provider.setCriticalMode(value),
          ),
          
          SizedBox(height: 20),
          
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'O Modo Crítico utiliza canais de notificação de alta prioridade '
                'para garantir que os alertas sejam percebidos mesmo em condições '
                'adversas.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}