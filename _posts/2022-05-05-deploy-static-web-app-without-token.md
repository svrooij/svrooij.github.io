---
title: "Deploy to Azure Static Web App with only the name"
published: true
categories:
  - Deploying
tags:
  - Static Web App
  - Azure CLI
twitter_image: /assets/images/2022/05/static-web-app-deploy.png
---

Ever heard of [Azure Static Web Apps](https://azure.microsoft.com/en-us/services/app-service/static/)? It combines a single page app (Angular/React/?) with Azure Functions, and manages it all for you.

The deployment is a breeze, as long as you have the **deployment token** available to your build pipeline. The deployment token should be kept a secret and you should save it somewhere secure.

<!--more-->

## Azure Resource Manager

We deploy all our applications using **arm templates**, that use a service principal connected to our Azure Subscription. All neatly managed in Azure DevOps.

ARM templates can have outputs, and it's possible to output the needed deploy token as a template output, but then the deploy token is saved in the deployment log as well. Which might not be such a good idea. In this case we only output the name of (new or pre-existing) the static web app.

Because the Static Web App might be created by the ARM deployment we cannot save the deployment token for the Static Web App in the secrets.

## Azure CLI to the rescue

You can use the Azure CLI to get the deployment token for any Static Web App, and the Azure CLI can use the same connection that is used by the Azure Resource Manager.

```yaml
  - task: AzureCLI@2
    displayName: 'Load deploy token for SWA'
    condition: and(succeeded(), ne(variables['swaName'], ''))
    env:
      SWA_NAME: $(swaName)
    inputs:
      # Name of the ARM connection
      azureSubscription: '$(azureSubscriptionConnection)'
      # All Platforms
      scriptType: 'pscore' 
      scriptLocation: 'inlineScript'
      inlineScript: |
        Write-Host "Getting deploy key for $env:SWA_NAME"
        $secretInfo = $(az staticwebapp secrets list --name $env:SWA_NAME) | ConvertFrom-JSON
        Write-Host "##vso[task.setvariable variable=swa-deploy-token;issecret=true;isreadonly=true;]$($secretInfo.properties.apiKey)"
```

This script will display the name in the logging, it will the call the azure cli to get the needed information and convert it to an object (instead of json). And finally it will write out a [special devops string](https://docs.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands?view=azure-devops&tabs=bash#setvariable-initialize-or-modify-the-value-of-a-variable) to create a secret variable called `swa-deploy-token`.

Powershell script highlighting

```powershell
Write-Host "Getting deploy key for $env:SWA_NAME"
$secretInfo = $(az staticwebapp secrets list --name $env:SWA_NAME) | ConvertFrom-JSON
Write-Host "##vso[task.setvariable variable=swa-deploy-token;issecret=true;isreadonly=true;]$($secretInfo.properties.apiKey)"
```

## Deploy Static web app as usual

You can now deploy the Static web app like you normally would, without the need to save the token in the pipeline. This makes deploying to a new Static Web App possible in one pipeline.

```yaml
  - task: AzureStaticWebApp@0
    displayName: Publish Static web app
    condition: and(succeeded(), ne(variables['swa-deploy-token'], ''))

    inputs:
      workingDirectory: '$(Pipeline.Workspace)'
      api_location: 'api.'
      app_location: 'spa/'
      output_location: ''
      skip_app_build: false
      config_file_location: ''
      azure_static_web_apps_api_token: '$(swa-deploy-token)'
```
