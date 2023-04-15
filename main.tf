terraform {
  required_version = ">= 0.13"
}

locals {
  k3s_env = {
    INSTALL_K3S_SKIP_DOWNLOAD     = var.skip_download,
    INSTALL_K3S_SYMLINK           = var.symlink,
    INSTALL_K3S_SKIP_ENABLE       = var.skip_enable,
    INSTALL_K3S_SKIP_START        = var.skip_start,
    INSTALL_K3S_VERSION           = var.k3s_version,
    INSTALL_K3S_BIN_DIR           = var.bin_dir,
    INSTALL_K3S_BIN_DIR_READ_ONLY = var.bin_dir_read_only,
    INSTALL_K3S_SYSTEMD_DIR       = var.systemd_dir,
    INSTALL_K3S_NAME              = var.name,
    INSTALL_K3S_TYPE              = var.type,
    INSTALL_K3S_SELINUX_WARN      = var.selinux_warn,
    INSTALL_K3S_SKIP_SELINUX_RPM  = var.skip_selinux_rpm,
    INSTALL_K3S_CHANNEL_URL       = var.channel_url,
    INSTALL_K3S_CHANNEL           = var.channel
  }
  server_args = [
    for server in var.server_nodes:
    replace(replace(var.server_args, "%(connect_ip)", server.connect_ip), "%(internal_ip)", server.internal_ip)
  ]
  agent_args = [
    for agent in var.agent_nodes:
    replace(replace(var.agent_args, "%(connect_ip)", agent.connect_ip), "%(internal_ip)", agent.internal_ip)
  ]
}

resource "random_password" "k3s_token" {
  length  = 64
  special = false
}

resource null_resource "server_node_init" {
  depends_on = [random_password.k3s_token]

  connection {
    type = "ssh"
    user = "root"
    host = var.server_nodes[0]["connect_ip"]
  }

  provisioner "remote-exec" {
    inline = concat(
      [
        for env_var in keys(local.k3s_env):
        "export ${env_var}='${local.k3s_env[env_var]}'"
        if local.k3s_env[env_var] != null
      ],
      [
        "export INSTALL_K3S_EXEC='server ${local.server_args[0]} --cluster-init'",
        "curl -sfL https://get.k3s.io | K3S_TOKEN='${random_password.k3s_token.result}' sh -"
      ]
    )
  }
}

resource null_resource "server_nodes" {
  depends_on = [null_resource.server_node_init]

  for_each = {
    for index, server in slice(var.server_nodes, 1, length(var.server_nodes)):
    index => server
  }

  connection {
    type = "ssh"
    user = "root"
    host = each.value.connect_ip
  }

  provisioner "remote-exec" {
    inline = concat(
      [
        for env_var in keys(local.k3s_env):
        "export ${env_var}='${local.k3s_env[env_var]}'"
        if local.k3s_env[env_var] != null
      ],
      [
        "export INSTALL_K3S_EXEC='server ${local.server_args[1 + each.key]}'",
        "export K3S_URL='https://${var.server_nodes[0]["internal_ip"]}:6443'",
        "curl -sfL https://get.k3s.io | K3S_TOKEN='${random_password.k3s_token.result}' sh -"
      ]
    )
  }
}

resource null_resource "agent_nodes" {
  depends_on = [null_resource.server_nodes]

  for_each = {
    for index, agent in var.agent_nodes:
    index => agent
  }

  connection {
    type = "ssh"
    user = "root"
    host = each.value.connect_ip
  }

  provisioner "remote-exec" {
    inline = concat(
      [
        for env_var in keys(local.k3s_env):
        "export ${env_var}='${local.k3s_env[env_var]}'"
        if local.k3s_env[env_var] != null
      ],
      [
        "export INSTALL_K3S_EXEC='agent ${local.agent_args[each.key]}'",
        "export K3S_URL='https://${var.server_nodes[0]["internal_ip"]}:6443'",
        "curl -sfL https://get.k3s.io | K3S_TOKEN='${random_password.k3s_token.result}' sh -"
      ]
    )
  }
}
