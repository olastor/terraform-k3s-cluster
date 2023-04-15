variable "server_nodes" {
  type = list(object({
    connect_ip  = string,
    internal_ip = string
  }))
}

variable "agent_nodes" {
  type = list(object({
    connect_ip  = string,
    internal_ip = string
  }))
  default = []
}

variable "server_args" {
  type    = string
  default = "--node-ip='%(internal_ip)' --node-external-ip='%(connect_ip)' --disable=traefik"
}

variable "agent_args" {
  type    = string
  default = "--node-ip='%(internal_ip)' --node-external-ip='%(connect_ip)' --disable=traefik"
}

# see https://docs.k3s.io/installation/configuration

variable "skip_download" {
  type        = bool
  default     = false
  description = "If set to true will not download K3s hash or binary."
}

variable "symlink" {
  type        = string
  default     = null
  description = "By default will create symlinks for the kubectl, crictl, and ctr binaries if the commands do not already exist in path. If set to 'skip' will not create symlinks and 'force' will overwrite."
}

variable "skip_enable" {
  type        = bool
  default     = false
  description = "If set to true will not enable or start K3s service."
}

variable "skip_start" {
  type        = bool
  default     = false
  description = "If set to true will not start K3s service."
}

variable "k3s_version" {
  type        = string
  description = "Version of K3s to download from Github. Will attempt to download from the stable channel if not specified."
}

variable "bin_dir" {
  type        = string
  default     = "/usr/local/bin"
  description = "Directory to install K3s binary, links, and uninstall script to, or use /usr/local/bin as the default."
}

variable "bin_dir_read_only" {
  type        = bool
  default     = false
  description = "If set to true will not write files to INSTALL_K3S_BIN_DIR, forces setting INSTALL_K3S_SKIP_DOWNLOAD=true."
}

variable "systemd_dir" {
  type        = string
  default     = "/etc/systemd/system"
  description = "Directory to install systemd service and environment files to, or use /etc/systemd/system as the default."
}

variable "name" {
  type        = string
  default     = "k3s"
  description = "Name of systemd service to create, will default to 'k3s' if running k3s as a server and 'k3s-agent' if running k3s as an agent. If specified the name will be prefixed with 'k3s-'."
}

variable "type" {
  type        = string
  default     = null
  description = "Type of systemd service to create, will default from the K3s exec command if not specified."
}

variable "selinux_warn" {
  type        = bool
  default     = false
  description = "If set to true will continue if k3s-selinux policy is not found."
}

variable "skip_selinux_rpm" {
  type        = bool
  default     = false
  description = "If set to true will skip automatic installation of the k3s RPM."
}

variable "channel_url" {
  type        = string
  default     = "https://update.k3s.io/v1-release/channels"
  description = "Channel URL for fetching K3s download URL. Defaults to https://update.k3s.io/v1-release/channels."
}

variable "channel" {
  type        = string
  default     = "stable"
  description = "Channel to use for fetching K3s download URL. Defaults to 'stable'. Options include: stable, latest, testing."
}
