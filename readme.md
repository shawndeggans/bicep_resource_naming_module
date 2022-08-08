# Azure Resource Naming Helper

I've been searching for a good way to name Azure resources. This module attempts to take Azure's recommended best practices for naming resources. I'd like something that's flexible, but still opinionated.

**Here are some of our basics:**

* Use lowercase
  
* Use hypens where permitted

* Starts and ends with alphanumeric

**Naming components:**

* Azure Region = region

* Environment - env

* Workload or Applicaiton Name = app

* Business unit = bunit

* Instance = instance

* Resource Type = resource

These values are captured in a parameters file, but you could just as easily pass these from another script. Ideally, this is a `module` that you call from your base Bicep file to help you name things.

## Parameters

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "resourceType": {
            "value": "azureStorageAccountDataLake"
        },
        "region": {
            "value": "eastus"
        },
        "environment": {
            "value": "dev"
        },
        "application": {
            "value": "deltalake"
        },
        "businessUnit": {
            "value": "hr"
        },
        "instance": {
            "value": "001"
        }
    }
}
```

## Testing

This module doesn't actually deploy anything, but you can test it using the Azure CLI and the provided `deploy.sh` script in this project. Simply grant permissions: `chmod u+x deploy.sh` and call the `deploys.sh` from your Azure CLI prompt using Bash. You will need to log into Azure for the test to execute.

My testing with a Virtual Machine created the name: `vm-eus-dev-webserver-sales-002`
My testing with a Data Lake Storage Account created the name: `adlseusdevdeltalakehr001`

To modify the order of the naming elements, just reorder the elements in the array:

```bicep
// EXAMPLE rg-eus2-dev-analytics-sales-01
var arrayResoureName = [
  resourceShortcode
  resourceLocation
  environment
  application
  businessUnit
  instance
]
var resourceWithDashes = join(arrayResoureName, '-')
var resourcNoDashes = join(arrayResoureName, '')

//We'll use this operator to determine which naming convetion to output
//var useDashes = resourceObject['naming-rules'] ? 'This is with dashes' : 'This has no dashes'
output resourceName string = toLower(sharedResourceTypes.resources[resourceType].namingRules.dashes ? resourceWithDashes : resourcNoDashes)
```

### TODO

This is a work-in-progress. Under the `.ref` directory you'll find the reference documents that feed the regions and resource types. They are not complete. As I add more resources I'll update these files, as well as the required fields for the main `deploy.bicep` file.
