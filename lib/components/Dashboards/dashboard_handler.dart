import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:bms/components/Dashboards/dash.dart';

class DashboardHandler extends StatefulWidget {
  final List<Map<String, String>> topics; // Pass topics via constructor
  final int initialIndex; // Pass initial index via constructor

  const DashboardHandler({
    Key? key,
    required this.topics,
    this.initialIndex = 0, // Default to 0 if not provided
  }) : super(key: key);

  @override
  _DashboardHandlerState createState() => _DashboardHandlerState();
}

class _DashboardHandlerState extends State<DashboardHandler> {
  final client = MqttServerClient.withPort(
    'broker.hivemq.com',
    'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    1883,
  );

  late final List<Map<String, String>> topics; // Topics from constructor
  late int currentIndex; // Current index from constructor

  Map<String, dynamic>? currentData;
  bool isLoading = true;
  Timer? loadingTimer;

  @override
  void initState() {
    super.initState();
    _initializeMQTT();
    topics = widget.topics; // Assign topics from widget
    currentIndex = widget.initialIndex; // Assign initial index from widget
    _startLoadingTimer();
  }

  Future<void> _initializeMQTT() async {
    client.logging(on: true);
    client.keepAlivePeriod = 20; // Keep-alive interval in seconds
    client.onConnected = () => debugPrint('MQTT Connected');
    client.onDisconnected = _handleDisconnection;
    client.onSubscribed =
        (String topic) => debugPrint('Subscribed to topic: $topic');
    client.onUnsubscribed =
        (String? topic) => debugPrint('Unsubscribed from topic: $topic');
    client.onSubscribeFail =
        (String topic) => debugPrint('Failed to subscribe: $topic');
    client.onAutoReconnect = () => debugPrint('Auto reconnecting...');
    client.onAutoReconnected = () {
      debugPrint('Auto reconnected');
      _subscribeToTopic(currentIndex); // Re-subscribe after reconnection
    };

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

  void _handleDisconnection() {
    debugPrint('MQTT Disconnected');
    _retryConnection();
  }

  void _retryConnection() async {
    debugPrint('Attempting to reconnect...');
    try {
      await client.connect();
    } catch (e) {
      debugPrint('Reconnection failed: $e');
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('Reconnected to MQTT broker');
      _subscribeToTopic(currentIndex);
    } else {
      debugPrint('Reconnection failed. Retrying in 5 seconds...');
      Future.delayed(const Duration(seconds: 5), _retryConnection);
    }
  }

  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? messages) {
    final recMess = messages![0].payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    if (messages[0].topic == topics[currentIndex]['topic_name']) {
      setState(() {
        try {
          final jsonData = jsonDecode(payload) as Map<String, dynamic>;
          if (jsonData != currentData) {
            currentData = jsonData;
            isLoading = false; // Data received, stop loading indicator
            loadingTimer?.cancel(); // Cancel the timeout timer
          }
        } catch (e) {
          debugPrint('Error parsing JSON: $e');
          currentData = null;
        }
      });
    }
  }

  void _subscribeToTopic(int index) {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      debugPrint('Cannot subscribe, client is not connected');
      return;
    }

    final topic = topics[index]['topic_name']!;
    if (topics[currentIndex]['topic_name'] != null) {
      client.unsubscribe(topics[currentIndex]['topic_name']!);
    }
    client.subscribe(topic, MqttQos.atLeastOnce);
    debugPrint('Subscribed to topic: $topic');
  }

  void _nextData() {
    setState(() {
      currentIndex = (currentIndex + 1) % topics.length;
      currentData = null;
      isLoading = true; // Reset loading indicator
      _startLoadingTimer(); // Restart the timeout timer
      _subscribeToTopic(currentIndex);
    });
  }

  void _previousData() {
    setState(() {
      currentIndex = (currentIndex - 1 + topics.length) % topics.length;
      currentData = null;
      isLoading = true; // Reset loading indicator
      _startLoadingTimer(); // Restart the timeout timer
      _subscribeToTopic(currentIndex);
    });
  }

  void _startLoadingTimer() {
    loadingTimer?.cancel();
    loadingTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
        currentData = null; // Data not received within timeout
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFFF),
        title: const Text("BMS DASHBOARD"),
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Waiting for the data to be loaded...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          else if (currentData != null)
            Dashboard(data: currentData!)
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Waiting for the data to be loaded...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          _getFloatingHeader(),
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

  Widget _getFloatingHeader() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.blue.withOpacity(0.8),
        child: Center(
          child: Text(
            topics[currentIndex]['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
    loadingTimer?.cancel();
    client.disconnect();
    super.dispose();
  }
}
