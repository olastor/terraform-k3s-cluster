# Terraform K3S Cluster

Basic Terraform module to install a k3s cluster on multiple nodes.

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_args"></a> [agent\_args](#input\_agent\_args) | n/a | `string` | `"--node-ip='%(internal_ip)' --node-external-ip='%(connect_ip)' --disable=traefik"` | no |
| <a name="input_agent_nodes"></a> [agent\_nodes](#input\_agent\_nodes) | n/a | <pre>list(object({<br>    connect_ip  = string,<br>    internal_ip = string<br>  }))</pre> | `[]` | no |
| <a name="input_bin_dir"></a> [bin\_dir](#input\_bin\_dir) | Directory to install K3s binary, links, and uninstall script to, or use /usr/local/bin as the default. | `string` | `"/usr/local/bin"` | no |
| <a name="input_bin_dir_read_only"></a> [bin\_dir\_read\_only](#input\_bin\_dir\_read\_only) | If set to true will not write files to INSTALL\_K3S\_BIN\_DIR, forces setting INSTALL\_K3S\_SKIP\_DOWNLOAD=true. | `bool` | `false` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel to use for fetching K3s download URL. Defaults to 'stable'. Options include: stable, latest, testing. | `string` | `"stable"` | no |
| <a name="input_channel_url"></a> [channel\_url](#input\_channel\_url) | Channel URL for fetching K3s download URL. Defaults to https://update.k3s.io/v1-release/channels. | `string` | `"https://update.k3s.io/v1-release/channels"` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Version of K3s to download from Github. Will attempt to download from the stable channel if not specified. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of systemd service to create, will default to 'k3s' if running k3s as a server and 'k3s-agent' if running k3s as an agent. If specified the name will be prefixed with 'k3s-'. | `string` | `"k3s"` | no |
| <a name="input_selinux_warn"></a> [selinux\_warn](#input\_selinux\_warn) | If set to true will continue if k3s-selinux policy is not found. | `bool` | `false` | no |
| <a name="input_server_args"></a> [server\_args](#input\_server\_args) | n/a | `string` | `"--node-ip='%(internal_ip)' --node-external-ip='%(connect_ip)' --disable=traefik"` | no |
| <a name="input_server_nodes"></a> [server\_nodes](#input\_server\_nodes) | n/a | <pre>list(object({<br>    connect_ip  = string,<br>    internal_ip = string<br>  }))</pre> | n/a | yes |
| <a name="input_skip_download"></a> [skip\_download](#input\_skip\_download) | If set to true will not download K3s hash or binary. | `bool` | `false` | no |
| <a name="input_skip_enable"></a> [skip\_enable](#input\_skip\_enable) | If set to true will not enable or start K3s service. | `bool` | `false` | no |
| <a name="input_skip_selinux_rpm"></a> [skip\_selinux\_rpm](#input\_skip\_selinux\_rpm) | If set to true will skip automatic installation of the k3s RPM. | `bool` | `false` | no |
| <a name="input_skip_start"></a> [skip\_start](#input\_skip\_start) | If set to true will not start K3s service. | `bool` | `false` | no |
| <a name="input_symlink"></a> [symlink](#input\_symlink) | By default will create symlinks for the kubectl, crictl, and ctr binaries if the commands do not already exist in path. If set to 'skip' will not create symlinks and 'force' will overwrite. | `string` | `null` | no |
| <a name="input_systemd_dir"></a> [systemd\_dir](#input\_systemd\_dir) | Directory to install systemd service and environment files to, or use /etc/systemd/system as the default. | `string` | `"/etc/systemd/system"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of systemd service to create, will default from the K3s exec command if not specified. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
