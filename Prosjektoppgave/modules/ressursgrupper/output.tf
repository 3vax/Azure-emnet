# outputs.tf (ressursgrupper)

output "ressursgrupper" {
  value = {
    for key, rg in azurerm_resource_group.rg : key => {
      name     = rg.name
      location = rg.location
      id       = rg.id
    }
  }
}

# Andre moduler kan bruke disse ressursgruppene på følgende måte:
# resource_group_name = module.ressursgrupper.ressursgrupper["dmz"].name
# dmz er nøkkelen til den ene ressursgruppen