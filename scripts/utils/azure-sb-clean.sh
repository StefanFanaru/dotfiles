#!/bin/bash
# Variables
resourceGroupName="apogy-EUW-test-RG"
namespaceName="apogy-euw-test-sb01"
messageThreshold=50

# Loop through each topic and then each subscription within that topic
for topic in $(az servicebus topic list --resource-group $resourceGroupName \
	--namespace-name $namespaceName \
	--query "[].name" -o tsv); do
	echo "Checking subscriptions for topic: $topic"

	# Loop through each subscription within the current topic
	for subscription in $(az servicebus topic subscription list --resource-group $resourceGroupName \
		--namespace-name $namespaceName \
		--topic-name $topic \
		--query "[].name" -o tsv); do
		# Get the active message count for the subscription
		activeMessageCount=$(az servicebus topic subscription show --resource-group $resourceGroupName \
			--namespace-name $namespaceName \
			--topic-name $topic \
			--name $subscription \
			--query "countDetails.activeMessageCount" -o tsv)

		# Convert activeMessageCount to an integer for comparison
		activeMessageCount=${activeMessageCount:-0}

		# Check if the active message count exceeds the threshold
		if ((activeMessageCount > messageThreshold)); then
			echo "Deleting subscription: $subscription in topic: $topic (Active Messages: $activeMessageCount)"
			az servicebus topic subscription delete --resource-group $resourceGroupName \
				--namespace-name $namespaceName \
				--topic-name $topic \
				--name $subscription
		else
			echo "Subscription: $subscription in topic: $topic has $activeMessageCount active messages, not deleting."
		fi
	done
done
