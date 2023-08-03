resource "shoreline_notebook" "high_request_rate_on_kafka_producer" {
  name       = "high_request_rate_on_kafka_producer"
  data       = file("${path.module}/data/high_request_rate_on_kafka_producer.json")
  depends_on = [shoreline_action.invoke_kafka_ping_script,shoreline_action.invoke_system_overload_detection,shoreline_action.invoke_stop_start_kafka]
}

resource "shoreline_file" "kafka_ping_script" {
  name             = "kafka_ping_script"
  input_file       = "${path.module}/data/kafka_ping_script.sh"
  md5              = filemd5("${path.module}/data/kafka_ping_script.sh")
  description      = "Check the network connection between the Kafka producer and consumer"
  destination_path = "/agent/scripts/kafka_ping_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "system_overload_detection" {
  name             = "system_overload_detection"
  input_file       = "${path.module}/data/system_overload_detection.sh"
  md5              = filemd5("${path.module}/data/system_overload_detection.sh")
  description      = "A sudden surge in demand for the service or application that is using the Kafka producer, leading to a high request rate."
  destination_path = "/agent/scripts/system_overload_detection.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_kafka" {
  name             = "stop_start_kafka"
  input_file       = "${path.module}/data/stop_start_kafka.sh"
  md5              = filemd5("${path.module}/data/stop_start_kafka.sh")
  description      = "Restart Kafka service to fix intermittent issues."
  destination_path = "/agent/scripts/stop_start_kafka.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kafka_ping_script" {
  name        = "invoke_kafka_ping_script"
  description = "Check the network connection between the Kafka producer and consumer"
  command     = "`chmod +x /agent/scripts/kafka_ping_script.sh && /agent/scripts/kafka_ping_script.sh`"
  params      = ["KAFKA_PRODUCER","KAFKA_CONSUMER"]
  file_deps   = ["kafka_ping_script"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_ping_script]
}

resource "shoreline_action" "invoke_system_overload_detection" {
  name        = "invoke_system_overload_detection"
  description = "A sudden surge in demand for the service or application that is using the Kafka producer, leading to a high request rate."
  command     = "`chmod +x /agent/scripts/system_overload_detection.sh && /agent/scripts/system_overload_detection.sh`"
  params      = ["KAFKA_BROKER","TOPIC_NAME"]
  file_deps   = ["system_overload_detection"]
  enabled     = true
  depends_on  = [shoreline_file.system_overload_detection]
}

resource "shoreline_action" "invoke_stop_start_kafka" {
  name        = "invoke_stop_start_kafka"
  description = "Restart Kafka service to fix intermittent issues."
  command     = "`chmod +x /agent/scripts/stop_start_kafka.sh && /agent/scripts/stop_start_kafka.sh`"
  params      = []
  file_deps   = ["stop_start_kafka"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_kafka]
}

