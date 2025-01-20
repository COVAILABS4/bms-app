import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:bms/components/Dashboards/dash.dart';

class DashboardHandler extends StatefulWidget {
  const DashboardHandler({Key? key}) : super(key: key);

  @override
  _DashboardHandlerState createState() => _DashboardHandlerState();
}

class _DashboardHandlerState extends State<DashboardHandler> {
  final client = MqttServerClient.withPort(
    'broker.hivemq.com',
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    1883,
  );

  final List<String> topics = ["bms-0", "bms-1", "bms-2", "bms-3"];
  Map<String, dynamic>? currentData;
  int currentIndex = 0;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeMQTT();
    _startAutoRefresh();
  }

  Future<void> _initializeMQTT() async {
    client.logging(on: true);
    client.onConnected = () => debugPrint('MQTT Connected');
    client.onDisconnected = () => debugPrint('MQTT Disconnected');
    client.onSubscribed =
        (String topic) => debugPrint('Subscribed to topic: $topic');
    client.onUnsubscribed =
        (String? topic) => debugPrint('Unsubscribed from topic: $topic');
    client.onSubscribeFail =
        (String topic) => debugPrint('Failed to subscribe: $topic');
    client.onAutoReconnect = () => debugPrint('Auto reconnecting...');
    client.onAutoReconnected = () => debugPrint('Auto reconnected');

    try {
      await client.connect();
    } catch (e) {
      debugPrint('MQTT Exception: $e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT Connected');
      _subscribeToTopic(currentIndex);
      client.updates!.listen(_onMessageReceived);
    } else {
      debugPrint('MQTT Connection failed: ${client.connectionStatus!.state}');
      client.disconnect();
    }
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    final recMess = messages![0].payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    if (messages[0].topic == topics[currentIndex]) {
      setState(() {
        try {
          final jsonData = jsonDecode(payload) as Map<String, dynamic>;
          if (jsonData != currentData) {
            currentData = jsonData;
          }
        } catch (e) {
          debugPrint('Error parsing JSON: $e');
          currentData = null;
        }
      });
    }
  }

  void _startAutoRefresh() {
    refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        _subscribeToTopic(currentIndex);
      }
    });
  }

  void _subscribeToTopic(int index) {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      debugPrint('Cannot subscribe, client is not connected');
      return;
    }

    final topic = topics[index];
    if (topics.contains(topics[currentIndex])) {
      client.unsubscribe(
          topics[currentIndex]); // Unsubscribe from the previous topic
    }
    client.subscribe(topic, MqttQos.atLeastOnce);
    debugPrint('Subscribed to topic: $topic');
  }

  void _nextData() {
    setState(() {
      currentIndex = (currentIndex + 1) % topics.length;
      currentData = null; // Reset current data
      _subscribeToTopic(currentIndex);
    });
  }

  void _previousData() {
    setState(() {
      currentIndex = (currentIndex - 1 + topics.length) % topics.length;
      currentData = null; // Reset current data
      _subscribeToTopic(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFFF),
        title: const Text("MEGATECH BMS"),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text("Button Pressed"),
                  );
                },
              );
            },
            child: const Text("C", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: currentData == null
          ? const Center(child: Text("No Data Found"))
          : Stack(
              children: [
                Dashboard(data: currentData!),
                _getButton(
                  left: 20,
                  top: 50,
                  onPressed: _previousData,
                  icon: Icons.arrow_back,
                ),
                _getButton(
                  right: 20,
                  top: 50,
                  onPressed: _nextData,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
    );
  }

  Widget _getButton({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Positioned(
      width: 40,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: const Color(0xFF00BFFF),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    client.disconnect();
    super.dispose();
  }
}
