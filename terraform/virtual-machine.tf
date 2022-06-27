# Créer une variable locale contenant le script user_data.sh encodé en base64
locals {
  custom_data = filebase64("files/user_data.sh")
}

# Créer une machine virtuelle qui va exécuter le script user_data
resource "azurerm_linux_virtual_machine" "vm_1" {
  depends_on            = [azurerm_network_interface.vm_1_nic]
  name                  = "vm-1"
  resource_group_name   = azurerm_resource_group.resource_group_1.name
  location              = azurerm_resource_group.resource_group_1.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  custom_data           = local.custom_data
  network_interface_ids = [azurerm_network_interface.vm_1_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("files/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# IP publiques v4 et v6
resource "azurerm_public_ip" "vm_1_public_ipv4" {
  name                = "vm-1_public_v4"
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name
  sku                 = "Standard"
  allocation_method   = "Static"
  ip_version          = "IPv4"
}
resource "azurerm_public_ip" "vm_1_public_ipv6" {
  name                = "vm-1_public_v6"
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv6"
  domain_name_label   = "ipv6azlb1"
}

# Créer une interface réseau virtuelle
resource "azurerm_network_interface" "vm_1_nic" {
  depends_on          = [azurerm_public_ip.vm_1_public_ipv4, azurerm_public_ip.vm_1_public_ipv6]
  name                = "vm-1_nic"
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name

  ip_configuration {
    primary                       = true
    name                          = "internal_v4"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_1_public_ipv4.id
  }
  ip_configuration {
    name                          = "public_v6"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_version    = "IPv6"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_1_public_ipv6.id
  }
}

# Créer un groupe de sécurité réseau qui autorise le SSH
resource "azurerm_network_security_group" "inbound_nsg" {
  name                = "vm-1_nic_inbound_nsg"
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name

  security_rule {
    name                       = "Port_22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Association du groupe de sécurité à l'interface virtuelle
resource "azurerm_network_interface_security_group_association" "inbound_nsg_association" {
  depends_on                = [azurerm_network_interface.vm_1_nic, azurerm_network_security_group.inbound_nsg]
  network_interface_id      = azurerm_network_interface.vm_1_nic.id
  network_security_group_id = azurerm_network_security_group.inbound_nsg.id
}
