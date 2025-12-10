/// Tela de Preferências - Configurações do sistema de notificações
/// 
/// Esta tela permite ao usuário configurar os tipos de notificação
/// (Vibração, Som e Banner) e alterar o Modo Crítico que permite
/// alertas mesmo com volume baixo ou modo Não Perturbe ativado
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';
import '../models/preferences.dart';

/// Tela que exibe as opções de preferências do usuário
class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferencesService>().preferences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurações de Notificação',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Vibração'),
                      subtitle: const Text('Habilitar vibração para notificações'),
                      value: prefs.vibrationEnabled,
                      onChanged: (value) => 
                        context.read<PreferencesService>().toggleVibration(),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Som'),
                      subtitle: const Text('Habilitar som para notificações'),
                      value: prefs.soundEnabled,
                      onChanged: (value) => 
                        context.read<PreferencesService>().toggleSound(),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Banner'),
                      subtitle: const Text('Mostrar notificações em banner'),
                      value: prefs.bannerEnabled,
                      onChanged: (value) => 
                        context.read<PreferencesService>().toggleBanner(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Modo Crítico',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SwitchListTile(
                  title: const Text('Modo Crítico'),
                  subtitle: const Text(
                    'Forçar alertas mesmo quando o dispositivo está no modo silencioso ou o Não Perturbe está ativo'
                  ),
                  value: prefs.criticalMode,
                  onChanged: (value) => 
                    context.read<PreferencesService>().toggleCriticalMode(),
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
                      'Sobre o Modo Crítico',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quando o Modo Crítico está habilitado, o aplicativo tentará contornar as configurações do sistema '
                      'como modo silencioso e Não Perturbe para garantir que alertas importantes sejam entregues. '
                      'Isso pode exigir permissões especiais em alguns dispositivos.',
                      style: Theme.of(context).textTheme.bodyMedium,
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