# main.tf (autoscale)

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = var.autoscale_name
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.target_resource_id
  enabled             = true

  profile {
    name = var.profile_name

    capacity {
      default = var.default_capacity
      minimum = var.minimum_capacity
      maximum = var.maximum_capacity
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.target_resource_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = var.scale_out_cooldown
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.target_resource_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = var.scale_in_cooldown
      }
    }
  }
}