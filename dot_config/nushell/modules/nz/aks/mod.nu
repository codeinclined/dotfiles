# Provides commands for working with AKS clusters

# Query Azure Resource Graph for information about all AKS clusters in your current tenant.
#
# By default, only clusters with a product and color tags are included.
# Providing the --all (-a) flag will include those clusters in the results.
#
# You can provide additional where clauses as arguments to this command.
# This results in less data being transmitted when you only need to work on a subset
# of clusters rather than just pulling everything and using nushell filters.
@category aks
@search-terms nz aks cluster k8s
export def clusters [
  --all (-a), # include clusters without product / color tags
  ...filters: string # additional 'where' clauses to apply to the graph query
] {
  let filters = if $all { $filters } else { $filters | append 'isnotempty(product) and isnotempty(color)' }

  print -e $filters

  ^az graph query -q ([
    'resources'
    '| where type =~ "Microsoft.ContainerService/managedClusters"' 
    '| extend product = tags.product, color = tags.color'
    ...($filters | each {|f| $'| where ($f)'})
    '| join kind=inner ('
    '    resourcecontainers'
    '    | where type =~ "microsoft.resources/subscriptions"'
    '    | project subscriptionId, subscriptionName = name'
    '  ) on subscriptionId'
    '| project name, resourceGroup, product, color, location, subscriptionName,'
    '          tags, properties, sku, subscriptionId, id, tenantId'
    ] | str join "\n")
  | from json
  | get data
  | (select name resourceGroup product color location subscriptionName
    tags properties sku subscriptionId id tenantId)
}

# Merge AKS clusters into your kubeconfig for each cluster within the piped-in table.
# A table of clusters can be generated using the `clusters` command.
@search-terms nz aks cluster k8s
@category aks
export def merge-creds []: table<name: string, resourceGroup: string, subscriptionId: string> -> nothing {
  for cluster in $in {
    (
      ^az aks get-credentials -n $cluster.name
                              -g $cluster.resourceGroup
                              --subscription $cluster.subscriptionId
                              --overwrite-existing
    )
  }
}
