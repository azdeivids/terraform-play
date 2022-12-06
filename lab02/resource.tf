resource "azurerm_service_plan" "appserviceplan" {
  name = "${var.appsvcname}-001"
  location = azurerm_resource_group.tfrg02.location
  resource_group_name = azurerm_resource_group.tfrg02.name
  os_type = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name = "${var.webappname}-001"
  location = azurerm_resource_group.tfrg02.location
  resource_group_name = azurerm_resource_group.tfrg02.name
  service_plan_id = azurerm_service_plan.appserviceplan.id
  https_only = true
  site_config {
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_app_service_source_control" "sourcecontorl" {
  app_id = azurerm_linux_web_app.webapp.id
  repo_url = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch = "master"
  use_manual_integration = false
  use_mercurial = false
}