import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MessageCallback = void Function(String topic, String message);

class MqttService {
  final String broker = '200.137.1.176';
  final int port = 1883;
  final String clientId = 'ssp_app';
  final String username = 'desafio09';
  final String password = 'desafio09.laica';

  final List<String> topics = [
    "ha/desafio09/yuri.aquino/ssp/vaga01",
    "ha/desafio09/yuri.aquino/ssp/vaga02",
    "ha/desafio09/yuri.aquino/ssp/vaga03",
    "ha/desafio09/yuri.aquino/ssp/vaga04",
    "ha/desafio09/yuri.aquino/ssp/vaga05"
  ];

  late MqttServerClient client;

  MessageCallback? onMessageReceived;

  Future<void> connect() async {
    client = MqttServerClient(broker, clientId);
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean();
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print(' 😊 Conectado ao broker MQTT com sucesso! 😊');
    } catch (e) {
      print('😔 :( Falha na conexão MQTT: 😔 $e');
      disconnect();
      return;
    }

    // Inscrever nos tópicos
    for (var topic in topics) {
      client.subscribe(topic, MqttQos.atMostOnce);
      print('✉️ Tentativa de inscrição no tópico ✉️: $topic');
    }

    // Escutar mensagens
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final recMess = message.payload as MqttPublishMessage;
        final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        // Imprime tópico e mensagem no console
        print('✉️✅Mensagem recebida -> Tópico:✅✉️ ${message.topic}, Mensagem: $payload');

        // Callback opcional para usar na UI
        if (onMessageReceived != null) {
          onMessageReceived!(message.topic, payload);
        }
      }
    });
  }
  void disconnect() => client.disconnect();

  void _onConnected() => print('✅ Conectado ao broker MQTT com sucesso! ✅');
  void _onDisconnected() => print('❌ Desconectado do broker MQTT ❌');
  void _onSubscribed(String topic) => print('✅ Inscrito no tópico: ✅ $topic');
}
