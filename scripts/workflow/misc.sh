#!/bin/bash

cloudinfo() {
    # Get currently selected Azure subscription
    azure_subscription=$(az account show --query 'name' -o tsv)

    # Get currently selected Kubernetes context
    kubernetes_context=$(kubectl config current-context)

    # Get currently selected Kubernetes namespace
    kubernetes_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')

    # Print the information in a pretty format
    info="Subscription: $azure_subscription\nContext: $kubernetes_context\nNamespace: $kubernetes_namespace"
    echo "$info" | bat --language="yaml" --style="plain"
}

