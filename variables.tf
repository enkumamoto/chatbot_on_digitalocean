
# Token de autenticação do DigitalOcean
variable "digitalocean_token" {
  description = "Token de API do DigitalOcean"
  type        = string
  sensitive   = true
}

# Configurações do projeto
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "meu-chatbot"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "O nome do projeto deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "environment" {
  description = "Ambiente de deployment (development, staging, production)"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "O ambiente deve ser development, staging ou production."
  }
}

# Configurações de região
variable "region" {
  description = "Região do DigitalOcean para deployment"
  type        = string
  default     = "nyc1"
}

variable "replica_region" {
  description = "Região para réplica do banco de dados"
  type        = string
  default     = "sfo3"
}

# Configurações do App Platform
variable "environment_slug" {
  description = "Environment slug para App Platform"
  type        = string
  default     = "node-js"
}

variable "app_instance_count" {
  description = "Número de instâncias da aplicação"
  type        = number
  default     = 1

  validation {
    condition     = var.app_instance_count >= 1 && var.app_instance_count <= 10
    error_message = "O número de instâncias deve estar entre 1 e 10."
  }
}

variable "app_instance_size" {
  description = "Tamanho das instâncias da aplicação"
  type        = string
  default     = "basic-xxs"

  validation {
    condition = contains([
      "basic-xxs", "basic-xs", "basic-s", "basic-m",
      "professional-xs", "professional-s", "professional-m", "professional-l"
    ], var.app_instance_size)
    error_message = "Tamanho de instância inválido."
  }
}

# Configurações do banco de dados
variable "database_size" {
  description = "Tamanho do cluster do banco de dados"
  type        = string
  default     = "db-s-1vcpu-1gb"

  validation {
    condition = contains([
      "db-s-1vcpu-1gb", "db-s-1vcpu-2gb", "db-s-2vcpu-4gb",
      "db-s-4vcpu-8gb", "db-s-6vcpu-16gb"
    ], var.database_size)
    error_message = "Tamanho de banco de dados inválido."
  }
}

variable "enable_database_replica" {
  description = "Habilitar réplica do banco de dados"
  type        = bool
  default     = false
}

# Configurações do repositório Git
variable "git_repo_url" {
  description = "URL do repositório Git"
  type        = string
  default     = "https://github.com/seu-usuario/seu-chatbot.git"
}

variable "git_branch" {
  description = "Branch do repositório Git"
  type        = string
  default     = "main"
}

# Configurações de domínio
variable "custom_domain" {
  description = "Domínio personalizado (deixe vazio se não quiser usar)"
  type        = string
  default     = ""
}

# Tags padrão
variable "default_tags" {
  description = "Tags padrão para aplicar a todos os recursos"
  type        = list(string)
  default     = ["terraform", "chatbot"]
}
