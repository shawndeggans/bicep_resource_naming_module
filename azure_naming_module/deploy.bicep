/*
************************************************
 █████╗ ███████╗██╗   ██╗██████╗ ███████╗    ███╗   ██╗ █████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗     ███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗
██╔══██╗╚══███╔╝██║   ██║██╔══██╗██╔════╝    ████╗  ██║██╔══██╗████╗ ████║██║████╗  ██║██╔════╝     ████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔════╝
███████║  ███╔╝ ██║   ██║██████╔╝█████╗      ██╔██╗ ██║███████║██╔████╔██║██║██╔██╗ ██║██║  ███╗    ██╔████╔██║██║   ██║██║  ██║██║   ██║██║     █████╗  
██╔══██║ ███╔╝  ██║   ██║██╔══██╗██╔══╝      ██║╚██╗██║██╔══██║██║╚██╔╝██║██║██║╚██╗██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██╔══╝  
██║  ██║███████╗╚██████╔╝██║  ██║███████╗    ██║ ╚████║██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗███████╗
╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
                                                                                                                                                         
This module is created with the intent to make naming modules somewhat flexible and safe.
Banner made with: https://manytools.org/hacker-tools/ascii-banner/ [ANSI Shadow]
************************************************
*/

@description('The type of resource registered with the Azure Naming Module.')
@allowed([
  'resourceGroup'
  'privateEndpoint'
  'virtualNetwork'
  'networkSecurityGroup'
  'bastion'
  'networkInterface'
  'publicIpAddress'
  'virtualMachine'
  'keyVault'
  'azureSynapse'
  'azureSynapsePrivateLinkHub'
  'azureAdGroup'
  'azureManagedIdentity'
  'databricks'
  'hdinsight'
  'azureDataFactory'
  'azureMachineLearning'
  'azureStreamAnalytics'
  'azureAnalysisServices'
  'eventHub'
  'azureDataExplorer'
  'azureDataShare'
  'azureTimeSeriesInsights'
  'microsoftPurview'
  'azureStorageAccount'
  'azureStorageAccountDataLake'
  'azureCosmosDb'
  'azureSqlServer'
  'azureSqldb'
  'azureMysql'
  'azureMariadb'
  'azurePostgresql'
  'dedicatedSqlPools'
  'powerPlatform'
  'iotHub'
  'iotCentral'
  'azureDigitalTwins'
])
param resourceType string

@description('Deployment Region - regions are limited to US and Gov locations. Regions are used to determine short code.')
@allowed([
  'eastus'
  'eastus2'
  'southcentralus'
  'westus'
  'westus2'
  'centralus'
  'northcentralus'
  'usdodcentralus'
  'usdodeast'
  'usgovarizona'
  'usgovtexas'
  'usgovvirginia'
])
param region string

@description('Environment options are dev and prod.')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('Workload or application name. Min character 3, Max character 12')
@minLength(3)
@maxLength(12)
param application string

@description('Business unit represents the project, department, or team responsible for the resource. Min 2, Max 6 characters')
@minLength(2)
@maxLength(6)
param businessUnit string

@description('The instance is used to give the resource uniqueness. When more than one resource is used, the instance manages multiples. Defaults to 01. Min 2, Max 4')
@minLength(2)
@maxLength(4)
param instance string = '01'

var sharedRegionCodes = json(loadTextContent('.ref/azure-regions.json'))
var resourceLocation = sharedRegionCodes.locations[region]
var sharedResourceTypes = json(loadTextContent('.ref/azure-resource-types.json'))
var resourceShortcode = sharedResourceTypes.resources[resourceType].abbreviation

/*
************************************************************************
Change the order or shape of these string to customize your naming convetion
************************************************************************
*/

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

