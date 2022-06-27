# auto-terraform-ansible
Projet perso automatisation ESGI

## Ansible

### Playbook base-config

Le playbook `base-config.yml` configure le système avec des paramètres et des paquets de base.
Il créé également un utilisateur nommé `christianvdz` et ajoutera une clé SSH au fichier `.ssh/authorized_keys`.

### Playbook docker

Le playbook `docker.yml` ajoute les dépôts où se trouvent les paquets Docker puis l'installe.
Il installe aussi `docker-compose`.

## Terraform

### resource-group.tf

Créé un groupe de resource nommé `resource-group-1` et dans la zone `West Europe`.

### virtual-network.tf

Créé un réseau virtuel nommé `vnet-1` portant les réseaux `10.0.0.0/16` et `fd00:db8:deca::/48` dans le groupe de ressources créé précédemment.  
Il créé ensuite un sous réseau privé `10.0.1.0/24` et `fd00:db8:deca:daed::/64` dans le réseau virtuel.

### virtual-machine.tf

Créé une machine virtuelle nommé `vm-1` dans le réseau privé créé précédemment et avec une IPv4 et une IPv6 publique.  
On créé et on associe un groupe de sécurité réseau autorisant le protocole SSH en entrée.

On utilise le script `user_data.sh` pour lancer les playbooks Ansible ci-dessus.

### Comment utiliser ce code ?

#### Pré-requis :

- avoir installé Terraform
- avoir installé Azure CLI
- avoir lancé la commande `az login`

#### Execution

Pour tester le code on utilise la commande `terraform plan`.
On obtiendra un dry-run des changements qui peuvent être faits.

<details>
<summary>Terraform plan</summary>

```terraform
❯ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.vm_1 will be created
  + resource "azurerm_linux_virtual_machine" "vm_1" {
      + admin_username                  = "adminuser"
      + allow_extension_operations      = true
      + computer_name                   = (known after apply)
      + custom_data                     = (sensitive value)
      + disable_password_authentication = true
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "vm-1"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "resource-group-1"
      + size                            = "Standard_B1s"
      + virtual_machine_id              = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFOi4BncuxaFOpeycqcvnpqR1sinBVrZ55AfVgsh7iRuQBWFw9fgDXk/4YY6+vFhyyDq+/+0yjNvzhwAZKizQzWdFWudtPKfJhQ5hzrLr3Gnvron2V04HLL77Vv0Cv5TIByrGu8saUWDhUcGEM4ZHb/nZogGCUmgd9uwJzrPw6+UmJOZUu1ejT/L5BGJiwUG+z/DGsCkyEjS0Ro6Ey7l6y1zVprXF1UtaAzuVX/OlAcSd+QabjauJBx33EhcUDuDtyVq57w2UZd+zMCFo3eETMe+UOA6Pv2CezswoVmRpbHs+2o5QrOfjXLuIVE++wOUjQm00JyGkT9cxRBoR9Z5F5WPOTRHriBuEKd7gUDaSzu6lKi/7Kk9RKzj2uYP9Au3hsJlkCAarAixFpCHm+C+qGzSM6SpFW1+UcEO2F8s2sEbytkVAjF535wO8ympOpE8hh0m9R8A/ltFghLdei/QcZTFI50nxqTHEqsyD5yV+E14OrHCNijsc82tDLAUz/f9U= christianvdz@MBP
            EOT
          + username   = "adminuser"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "Canonical"
          + sku       = "18.04-LTS"
          + version   = "latest"
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_network_interface.vm_1_nic will be created
  + resource "azurerm_network_interface" "vm_1_nic" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "westeurope"
      + mac_address                   = (known after apply)
      + name                          = "vm-1_nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "resource-group-1"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal_v4"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "public_v6"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv6"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_security_group_association.inbound_nsg_association will be created
  + resource "azurerm_network_interface_security_group_association" "inbound_nsg_association" {
      + id                        = (known after apply)
      + network_interface_id      = (known after apply)
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.inbound_nsg will be created
  + resource "azurerm_network_security_group" "inbound_nsg" {
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "vm-1_nic_inbound_nsg"
      + resource_group_name = "resource-group-1"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Port_22"
              + priority                                   = 100
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
    }

  # azurerm_public_ip.vm_1_public_ipv4 will be created
  + resource "azurerm_public_ip" "vm_1_public_ipv4" {
      + allocation_method       = "Static"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "vm-1_public_v4"
      + resource_group_name     = "resource-group-1"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_public_ip.vm_1_public_ipv6 will be created
  + resource "azurerm_public_ip" "vm_1_public_ipv6" {
      + allocation_method       = "Static"
      + domain_name_label       = "ipv6azlb1"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv6"
      + location                = "westeurope"
      + name                    = "vm-1_public_v6"
      + resource_group_name     = "resource-group-1"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.resource_group_1 will be created
  + resource "azurerm_resource_group" "resource_group_1" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "resource-group-1"
    }

  # azurerm_subnet.subnet_1 will be created
  + resource "azurerm_subnet" "subnet_1" {
      + address_prefixes                               = [
          + "10.0.1.0/24",
          + "fd00:db8:deca:daed::/64",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "vnet-1_internal"
      + resource_group_name                            = "resource-group-1"
      + virtual_network_name                           = "vnet-1"
    }

  # azurerm_virtual_network.virtual_network_1 will be created
  + resource "azurerm_virtual_network" "virtual_network_1" {
      + address_space       = [
          + "10.0.0.0/16",
          + "fd00:db8:deca::/48",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "vnet-1"
      + resource_group_name = "resource-group-1"
      + subnet              = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy.
```

</details>

Pour appliquer le code on utilise la commande `terraform apply`.
On obtiendra aussi un dry-run des changements mais cette fois, on nous demandera si l'on veut faire les changements.

<details>
<summary>Terraform apply</summary>

```terraform
❯ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_linux_virtual_machine.vm_1 will be created
  + resource "azurerm_linux_virtual_machine" "vm_1" {
      + admin_username                  = "adminuser"
      + allow_extension_operations      = true
      + computer_name                   = (known after apply)
      + custom_data                     = (sensitive value)
      + disable_password_authentication = true
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "vm-1"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "resource-group-1"
      + size                            = "Standard_B1s"
      + virtual_machine_id              = (known after apply)

      + admin_ssh_key {
          + public_key = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFOi4BncuxaFOpeycqcvnpqR1sinBVrZ55AfVgsh7iRuQBWFw9fgDXk/4YY6+vFhyyDq+/+0yjNvzhwAZKizQzWdFWudtPKfJhQ5hzrLr3Gnvron2V04HLL77Vv0Cv5TIByrGu8saUWDhUcGEM4ZHb/nZogGCUmgd9uwJzrPw6+UmJOZUu1ejT/L5BGJiwUG+z/DGsCkyEjS0Ro6Ey7l6y1zVprXF1UtaAzuVX/OlAcSd+QabjauJBx33EhcUDuDtyVq57w2UZd+zMCFo3eETMe+UOA6Pv2CezswoVmRpbHs+2o5QrOfjXLuIVE++wOUjQm00JyGkT9cxRBoR9Z5F5WPOTRHriBuEKd7gUDaSzu6lKi/7Kk9RKzj2uYP9Au3hsJlkCAarAixFpCHm+C+qGzSM6SpFW1+UcEO2F8s2sEbytkVAjF535wO8ympOpE8hh0m9R8A/ltFghLdei/QcZTFI50nxqTHEqsyD5yV+E14OrHCNijsc82tDLAUz/f9U= christianvdz@MBP
            EOT
          + username   = "adminuser"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "Canonical"
          + sku       = "18.04-LTS"
          + version   = "latest"
        }

      + termination_notification {
          + enabled = (known after apply)
          + timeout = (known after apply)
        }
    }

  # azurerm_network_interface.vm_1_nic will be created
  + resource "azurerm_network_interface" "vm_1_nic" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "westeurope"
      + mac_address                   = (known after apply)
      + name                          = "vm-1_nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "resource-group-1"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal_v4"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "public_v6"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv6"
          + public_ip_address_id                               = (known after apply)
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_security_group_association.inbound_nsg_association will be created
  + resource "azurerm_network_interface_security_group_association" "inbound_nsg_association" {
      + id                        = (known after apply)
      + network_interface_id      = (known after apply)
      + network_security_group_id = (known after apply)
    }

  # azurerm_network_security_group.inbound_nsg will be created
  + resource "azurerm_network_security_group" "inbound_nsg" {
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "vm-1_nic_inbound_nsg"
      + resource_group_name = "resource-group-1"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "22"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "Port_22"
              + priority                                   = 100
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
    }

  # azurerm_public_ip.vm_1_public_ipv4 will be created
  + resource "azurerm_public_ip" "vm_1_public_ipv4" {
      + allocation_method       = "Static"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "vm-1_public_v4"
      + resource_group_name     = "resource-group-1"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_public_ip.vm_1_public_ipv6 will be created
  + resource "azurerm_public_ip" "vm_1_public_ipv6" {
      + allocation_method       = "Static"
      + domain_name_label       = "ipv6azlb1"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv6"
      + location                = "westeurope"
      + name                    = "vm-1_public_v6"
      + resource_group_name     = "resource-group-1"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
    }

  # azurerm_resource_group.resource_group_1 will be created
  + resource "azurerm_resource_group" "resource_group_1" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "resource-group-1"
    }

  # azurerm_subnet.subnet_1 will be created
  + resource "azurerm_subnet" "subnet_1" {
      + address_prefixes                               = [
          + "10.0.1.0/24",
          + "fd00:db8:deca:daed::/64",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "vnet-1_internal"
      + resource_group_name                            = "resource-group-1"
      + virtual_network_name                           = "vnet-1"
    }

  # azurerm_virtual_network.virtual_network_1 will be created
  + resource "azurerm_virtual_network" "virtual_network_1" {
      + address_space       = [
          + "10.0.0.0/16",
          + "fd00:db8:deca::/48",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "vnet-1"
      + resource_group_name = "resource-group-1"
      + subnet              = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

</details>
