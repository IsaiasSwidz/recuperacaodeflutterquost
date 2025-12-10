# Aplicativo de Monitoramento e Alertas

Um aplicativo Flutter para monitoramento e notificações de alerta com recursos de modo crítico.

## Recursos

- **Tela de Dashboard**: Mostra o status do sistema e permite acionar alertas
- **Tela de Preferências**: Configuração das notificações e modo crítico
- **Tela de Histórico**: Visualização de todos os eventos acionados com timestamps
- **Notificações Locais**: Notificações nativas que funcionam em segundo plano
- **Modo Crítico**: Contorna o modo silencioso e Não Perturbe
- **Persistência Local**: SQLite para eventos, SharedPreferences para preferências
- **Integração com API**: Integração com API pública (JSONPlaceholder)
- **Gerenciamento de Estado**: Padrão Provider para gerenciamento de estado
- **Testes Unitários**: Cobertura abrangente de testes

## Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do aplicativo
├── models/
│   ├── event.dart           # Modelo de Evento
│   └── preferences.dart     # Modelo de Preferências
├── services/
│   ├── notification_service.dart  # Notificações locais
│   ├── preferences_service.dart   # Gerenciamento de preferências
│   ├── database_service.dart      # Operações de banco de dados local
│   └── api_service.dart           # Integração com API
├── screens/
│   ├── dashboard_screen.dart     # Dashboard principal
│   ├── preferences_screen.dart   # Tela de configurações
│   └── history_screen.dart       # Histórico de eventos
└── widgets/
    └── status_card.dart          # Componente de UI reutilizável
```

## Dependências

- `flutter_local_notifications`: Para notificações locais
- `provider`: Para gerenciamento de estado
- `shared_preferences`: Para persistência de preferências
- `sqflite`: Para banco de dados local
- `http`: Para integração com API
- `permission_handler`: Para permissões de notificação

## Como Executar

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Execute `flutter pub get`
4. Execute `flutter run`

## Funcionalidades Principais

### Tela de Dashboard
- Alternância de ativação do sistema
- Simulação de alertas com o botão de pânico
- Visualização dos resultados da integração com API
- Acesso rápido às preferências de notificação

### Tela de Preferências
- Habilitar/desabilitar vibração, som e notificações em banner
- Alternar modo crítico para contornar modo silencioso
- Configurações persistidas usando SharedPreferences

### Tela de Histórico
- Lista todos os eventos acionados
- Mostra tipo de evento, descrição e timestamp
- Dados persistidos no banco de dados SQLite

### Notificações
- Notificações locais que funcionam em segundo plano
- Notificações críticas que contornam o modo silencioso
- Tratamento adequado de permissões

### Integração com API
- Busca dados de usuário da API JSONPlaceholder
- Exibe resultados da API no dashboard
- Tratamento de erros para requisições de rede

## Testes

O projeto inclui testes unitários para:
- Serviço de preferências
- Serviço de banco de dados
- Modelo de evento

Execute os testes com:
```bash
flutter test
```

## Suporte a Plataformas

Este aplicativo é projetado para as plataformas Android e iOS com suporte a notificações nativas.

## Arquitetura

O aplicativo segue um padrão de arquitetura limpa com:
- Modelos para representação de dados
- Serviços para lógica de negócios
- Telas para interface do usuário
- Gerenciamento de estado usando Provider
- Adequada separação de responsabilidades