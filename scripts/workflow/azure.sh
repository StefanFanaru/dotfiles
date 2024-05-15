function azs {
    # List Azure subscriptions and extract names
    subscriptions=$(az account list --query "[].name" --output tsv)

    # Use fzf to interactively select a subscription
    selected_subscription=$(echo "$subscriptions" | fzf --ansi --no-info --header="Select Azure Subscription")

    if [ -n "$selected_subscription" ]; then
        # Set the selected subscription
        az account set --subscription "$selected_subscription"

        echo "Switched to Azure subscription: $selected_subscription"
    else
        echo "No subscription selected."
    fi
}

