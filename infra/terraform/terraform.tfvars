project_name  = "project2-najla"
location      = "Japan East"

address_space = ["10.30.0.0/16"]

appgw_id       = "/subscriptions/.../resourceGroups/project2-rg-najla/providers/Microsoft.Network/applicationGateways/proj2-najla-appgw"
vm_frontend_id = "/subscriptions/.../resourceGroups/project2-rg-najla/providers/Microsoft.Compute/virtualMachines/proj2-najla-frontend"
vm_backend_id  = "/subscriptions/.../resourceGroups/project2-rg-najla/providers/Microsoft.Compute/virtualMachines/proj2-najla-backend"
sql_db_id      = "/subscriptions/.../resourceGroups/project2-rg-najla/providers/Microsoft.Sql/servers/proj2-najla-sqlsrv/databases/proj2-najla-db"


subnets = {
  appgw    = { cidr = "10.30.0.0/24" }
  frontend = { cidr = "10.30.1.0/24" }
  backend  = { cidr = "10.30.2.0/24" }
  data     = { cidr = "10.30.3.0/24" }
  mgmt     = { cidr = "10.30.10.0/24" }
  bastion  = { cidr = "10.30.100.0/27" }
}
