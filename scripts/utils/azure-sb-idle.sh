# Variables
resourceGroupName="apogy-EUW-dev-RG"
namespaceName="apogy-euw-dev-sb01"
idleTime="PT1H" # Change to desired idle time

for topic in $(az servicebus topic list --resource-group $resourceGroupName \
	--namespace-name $namespaceName \
	--query "[].name" -o tsv); do
	echo "Processing topic: $topic"

	# Loop through each subscription within the current topic
	for subscription in $(az servicebus topic subscription list --resource-group $resourceGroupName \
		--namespace-name $namespaceName \
		--topic-name $topic \
		--query "[].name" -o tsv); do
		echo "Updating subscription: $subscription in topic: $topic"

		# Update both the auto-delete and message time to live settings for the subscription
		az servicebus topic subscription update --resource-group $resourceGroupName \
			--namespace-name $namespaceName \
			--topic-name $topic \
			--name $subscription \
			--auto-delete-on-idle $idleTime \
			--default-message-time-to-live $idleTime
	done
done

for queue in $(az servicebus queue list --resource-group $resourceGroupName \
	--namespace-name $namespaceName \
	--query "[].name" -o tsv); do
	echo "Updating queue: $queue"

	az servicebus queue update --resource-group $resourceGroupName \
		--namespace-name $namespaceName \
		--name $queue \
		--auto-delete-on-idle $idleTime \
		--default-message-time-to-live $idleTime
done
