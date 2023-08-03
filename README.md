
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High request rate on Kafka producer.
---

This incident type is related to a high request rate on a Kafka producer. This could be caused by a sudden increase in traffic or a malfunction in the producer system. This incident can cause delays in message processing and may lead to data loss or system failure if not addressed promptly. It is important to identify the root cause of this incident and take appropriate measures to prevent similar incidents in the future.

### Parameters
```shell
# Environment Variables

export KAFKA_PRODUCER="PLACEHOLDER"

export KAFKA_CONSUMER="PLACEHOLDER"

export KAFKA_BROKER="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_HOST_PORT="PLACEHOLDER"

```

## Debug

### Check the network connection between the Kafka producer and consumer
```shell
ping ${KAFKA_PRODUCER}

ping ${KAFKA_CONSUMER}
```

### Check if the Kafka producer is running
```shell
systemctl status ${KAFKA_PRODUCER}
```

### Check the Kafka producer logs for any errors or warnings
```shell
journalctl -u ${KAFKA_PRODUCER} -f
```

### Check the Kafka broker logs for any errors or warnings
```shell
journalctl -u ${KAFKA_BROKER} -f
```

### Check if the Kafka topic is created and has the expected number of partitions
```shell
kafka-topics --zookeeper ${ZOOKEEPER_HOST_PORT} --describe --topic ${TOPIC_NAME}
```

### Check if the Kafka consumer is running
```shell
systemctl status ${KAFKA_CONSUMER}
```

### Check the Kafka consumer logs for any errors or warnings
```shell
journalctl -u ${KAFKA_CONSUMER} -f
```

### Check the CPU and memory usage of the Kafka producer and consumer processes
```shell
top 
```

### Check the network traffic between the Kafka producer and consumer
```shell
tcpdump -i eth01 port 9092
```

### A sudden surge in demand for the service or application that is using the Kafka producer, leading to a high request rate.
```shell
#!/bin/bash

# Set parameters

REQUEST_THRESHOLD="PLACEHOLDER"

TIME_PERIOD="PLACEHOLDER"

# Get request rate

request_rate=$(kafka-console-consumer.sh --bootstrap-server ${KAFKA_BROKER} --topic $TOPIC_NAME --from-beginning --timeout-ms 1000 | wc -l)

# Check if request rate exceeds threshold

if [ $request_rate -gt $REQUEST_THRESHOLD ]

then

    echo "High request rate detected: $request_rate requests in the last $TIME_PERIOD seconds."

# Check for system overload

    cpu_usage=$(top -bn1 | awk '/Cpu/ {print $2}' | sed 's/%//')

    memory_usage=$(free | awk '/Mem/ {printf("%.2f"), $3/$2*100}')

    if [ $(echo "$cpu_usage > 80" | bc -l) -eq 1 ] || [ $(echo "$memory_usage > 80" | bc -l) -eq 1 ]

    then

        echo "System overload detected: CPU usage is at $cpu_usage% and memory usage is at $memory_usage%."

        # Take appropriate action here, such as scaling up the system or offloading traffic.

    else

        echo "System overload not detected. Check for other possible causes."

        # Check for other possible causes here, such as network issues or inefficient code.

    fi

else

    echo "Request rate within normal limits."

fi

```

## Repair

### Restart Kafka service to fix intermittent issues.
```shell
bash

#!/bin/bash

# stop the Kafka cluster

systemctl stop kafka

# start the Kafka cluster

systemctl start kafka
```