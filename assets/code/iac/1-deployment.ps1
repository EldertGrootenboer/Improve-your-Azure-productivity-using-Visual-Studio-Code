# What we will be doing in this script.
#   1. Create a resource group
#   2. Deploy Azure services

# Update these according to the environment
$subscriptionName = "Visual Studio Enterprise"
$resourceGroupName = "rg-improve-your-azure-productivity-using-vs-code"
$basePath = "C:\Users\elder\OneDrive\Sessions\Improve-your-Azure-productivity-using-Visual-Studio-Code"

# Login to Azure
Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

# Create the resource group and deploy the resources
New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Improve your Azure productivity using Visual Studio Code"; Purpose="Session"} -Force
New-AzResourceGroupDeployment -Name "ProductivityVSCode" -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\assets\code\iac\azuredeploy.json"

# Deploy contents of the Function
dotnet publish "$basePath\assets\demo\1-functions\1-functions.csproj" -c Release -o "$basePath\assets\demo\1-functions\publish"
Compress-Archive -Path "$basePath\assets\demo\1-functions\publish\*" -DestinationPath "$basePath\assets\demo\1-functions\Deployment.zip" -Force
$functionApp = Get-AzResource -ResourceGroupName $resourceGroupName -Name func-*
Publish-AzWebapp -ResourceGroupName $resourceGroupName -Name $functionApp.Name -ArchivePath "$basePath\assets\demo\1-functions\Deployment.zip" -Force
Remove-Item "$basePath\assets\demo\1-functions\Deployment.zip" -Force

# Optional for debugging, loops through each local file individually
#Get-ChildItem "$basePath\assets\code\iac" -Filter *.json | 
#Foreach-Object {
#    Write-Output "Deploying: " $_.FullName
#    New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile $_.FullName -ErrorAction Continue
#}