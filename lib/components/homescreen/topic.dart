class Topic {
  String name;
  String topicName;

  Topic({required this.name, required this.topicName});

  // Convert Topic object to Map
  Map<String, String> toMap() {
    return {"name": name, "topic_name": topicName};
  }

  // Create a Topic object from Map
  factory Topic.fromMap(Map<String, String> map) {
    return Topic(name: map['name']!, topicName: map['topic_name']!);
  }
}
