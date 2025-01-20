import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SubscribePage(),
    );
  }
}

class SubscribePage extends StatefulWidget {
  const SubscribePage({super.key});

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  List<dynamic> dataList = []; // Parsed data list
  late MqttServerClient client; // MQTT client
  final String topic = 'bms-1'; // Topic to subscribe to
  bool isConnecting = true; // MQTT connection state
  String errorMessage = ""; // Error message for display

  @override
  void initState() {
    super.initState();
    initMqtt();
  }

  void initMqtt() async {
    client = MqttServerClient.withPort(
      'broker.hivemq.com',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );

    // Configure MQTT client
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    try {
      await client.connect();
    } catch (e) {
      setState(() {
        isConnecting = false;
        errorMessage = 'MQTT Connection Error: $e';
      });
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      setState(() => isConnecting = false);
      debugPrint('MQTT connected');
      client.subscribe(topic, MqttQos.atLeastOnce);

      // Listen for incoming messages
      client.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
        final MqttPublishMessage recMess =
            messages![0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        debugPrint(
            'Received message: $payload from topic: ${messages[0].topic}');

        try {
          // Decode JSON and cast to List<Map<String, dynamic>> based on expected format
          final List<dynamic> parsedData = jsonDecode(payload);

          // Process the data to match the expected structure of the mock data
          setState(() {
            dataList = parsedData.map((e) {
              if (e is Map<String, dynamic>) {
                return {
                  'name': e['name'] ?? '',
                  'mac_address': e['mac_address'] ?? '',
                  'soc': e['soc'] ?? 0,
                  'states': e['states'] ?? {},
                  'svi': (e['svi'] as List<dynamic>?)
                      ?.map((svi) => {
                            'name': svi['name'] ?? '',
                            'value': svi['value']?.toDouble() ?? 0.0
                          })
                      .toList(),
                  'temperature': (e['temperature'] as List<dynamic>?)
                      ?.map((temp) => {
                            'mos': temp['mos']?.toDouble() ?? 0.0,
                            '1': temp['1']?.toDouble() ?? 0.0,
                            '2': temp['2']?.toDouble() ?? 0.0
                          })
                      .toList(),
                  'values': {
                    'total_volt': e['values']?['total_volt']?.toDouble() ?? 0.0,
                    'current': e['values']?['current']?.toDouble() ?? 0.0,
                    'power': e['values']?['power']?.toDouble() ?? 0.0,
                    'vol_high': e['values']?['vol_high']?.toDouble() ?? 0.0,
                    'vol_low': e['values']?['vol_low']?.toDouble() ?? 0.0,
                    'vol_diff': e['values']?['vol_diff']?.toDouble() ?? 0.0,
                    'ave_vol': e['values']?['ave_vol']?.toDouble() ?? 0.0,
                    'cycle_index': e['values']?['cycle_index'] ?? 0,
                  }
                };
              } else {
                return {}; // Return empty map if data is malformed
              }
            }).toList();
          });
        } catch (e) {
          debugPrint('Error parsing JSON: $e');
        }
      });
    } else {
      setState(() {
        isConnecting = false;
        errorMessage = 'MQTT Connection failed - disconnecting';
      });
      client.disconnect();
    }
  }

  void onDisconnected() {
    debugPrint('Disconnected from MQTT broker');
    setState(() {
      isConnecting = false;
      errorMessage = 'Disconnected from MQTT broker';
    });
  }

  void onConnected() {
    debugPrint('Connected to MQTT broker');
  }

  void onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscribed Data')),
      body: isConnecting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : dataList.isNotEmpty
                  ? ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final item = dataList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: item.entries.map((entry) {
                                return Text('${entry.key}: ${entry.value}');
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No data received yet'),
                    ),
    );
  }
}
