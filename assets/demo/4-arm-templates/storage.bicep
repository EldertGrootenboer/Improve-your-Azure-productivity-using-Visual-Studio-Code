resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'bicepstorage001' // must be globally unique
  location: 'westeurope'
  kind: 'Storage'
  sku: {
      name: 'Standard_LRS'
  }
}