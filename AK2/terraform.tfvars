
# Provider og autentiseringsdetaljer
subscription_id = "REMOVED"
location = "France Central"

# Ressursgruppenavn
rg_name = "AK2-RG-01"

# Virtuelt nettverk og subnett detaljer
vnet_name = "AK2-VNET-01"
ip_range = "192.168.50.0/24"

subnet_names = ["AK2-SUBNET-01", "AK2-SUBNET-02"]
subnet_ip_ranges = ["192.168.50.0/25", "192.168.50.128/25"]


existing_vnet_resource_group_name = "Ansible-controller"
existing_vnet_name = "ansible-controller-vm-vnet"

# Offentlig IP-detaljer
public_ip_name = "AK2-PUBLIC-IP-01"

# NSG detaljer
nsg_name_01 = "AK2-NSG-01"
ssh_source_address_prefix = "10.1.1.0/24"

# Load Balancer detaljer
lb_name = "AK2-LB-01"
lb_frontend_name = "AK2-LB-FRONTEND-01"
lb_backend_pool_names = ["AK2-LB-BACKEND-01"]

http_probe_name = "AK2-HTTP-PROBE-01"

# VM detaljer
vm_names = ["AK2-VM-01", "AK2-VM-02"]
vm_admin_username = "adminuser"
vm_admin_password = "P@ssw0rd1234!"
public_key_path = "C:\\Users\\Hauk\\.ssh\\id_ed25519.pub"