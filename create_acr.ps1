$ACR_NAME="testacrtask"
$RES_GROUP=$ACR_NAME # Resource Group name

#step 1
#az group create --resource-group $RES_GROUP --location eastus
#az acr create --resource-group $RES_GROUP --name $ACR_NAME --sku Standard --location eastus

#step 2
#az acr build --registry $ACR_NAME --image helloacrtasks:v1 .

# az acr update --name testacrtask --admin-enabled true


#step 3
$AKV_NAME=$ACR_NAME+"-vault"
#az keyvault create --resource-group $RES_GROUP --name $AKV_NAME

#step 4
#Create service principal, store its password in AKV (the registry *password*)
# az keyvault secret set `
#   --vault-name $AKV_NAME `
#   --name $ACR_NAME-pull-pwd `
#   --value $(az ad sp create-for-rbac `
#                 --name $ACR_NAME-pull `
#                 --scopes $(az acr show --name $ACR_NAME --query id --output tsv) `
#                 --role acrpull `
#                 --query password `
#                 --output tsv)

# Step 5
# Store service principal ID in AKV (the registry *username*)
# az keyvault secret set `
#     --vault-name $AKV_NAME `
#     --name $ACR_NAME-pull-usr `
#     --value $(az ad sp list --display-name $ACR_NAME-pull --query [].appId --output tsv)

# Step 6
#  az container create `
#      --resource-group $RES_GROUP `
#      --name acr-tasks `
#      --image $ACR_NAME.azurecr.io/helloacrtasks:v1 `
#      --registry-username $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-usr --query value -o tsv) `
#      --registry-password $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-pwd --query value -o tsv) `
#      --dns-name-label acr-tasks-$ACR_NAME `
#      --query "{FQDN:ipAddress.fqdn}" `
#      --output table


#az container create -g $RES_GROUP --name acr-tasks --image $ACR_NAME.azurecr.io/helloacrtasks:v1 

$GIT_USER = "rdu16625"
az acr task create `
  --name timertask `
  --registry $ACR_NAME `
  --context https://github.com/$GIT_USER/acr-build-helloworld-node.git#master `
  --file Dockerfile `
  --image timertask:{{.Run.ID}} `
  --git-access-token $GIT_PAT `
  --schedule "0 21 * * *"



  az acr task create --name timertask --registry testacrtask  --cmd mcr.microsoft.com/hello-world --schedule "0 21 * * *" --context /dev/null