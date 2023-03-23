#    --git-access-token mytoken \
# --timezone "Pacific Standard Time" `
az acr task create `
    --name hello-world `
    --registry testacrtask `
    --image helloacrtasks:v1 `
    --cmd '$Registry/helloacrtasks:v1' `
    --schedule "0 */12 * * *" `
    --platform linux/amd64 `
    --context /dev/null

#az acr task create -n hello-world -r MyRegistry --cmd '$Registry/myimage' -c /dev/null


#az acr task show --name mytask --registry testacrtask --output table


az acr task run --name hello-world --registry testacrtask

az acr task cancel --registry testacrtask --run-id ca7
