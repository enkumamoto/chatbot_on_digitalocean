
# URLs e endpoints da aplicação
output "app_live_url" {
  description = "URL da aplicação no App Platform"
  value       = digitalocean_app.chatbot_app.live_url
}

output "app_id" {
  description = "ID da aplicação no App Platform"
  value       = digitalocean_app.chatbot_app.id
}

output "app_urn" {
  description = "URN da aplicação"
  value       = digitalocean_app.chatbot_app.urn
}

# Informações do banco de dados
output "database_host" {
  description = "Host do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.host
  sensitive   = true
}

output "database_port" {
  description = "Porta do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.port
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.database
}

output "database_user" {
  description = "Usuário do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.user
  sensitive   = true
}

output "database_password" {
  description = "Senha do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.password
  sensitive   = true
}

output "database_uri" {
  description = "URI completa do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.uri
  sensitive   = true
}

output "database_private_uri" {
  description = "URI privada do banco de dados"
  value       = digitalocean_database_cluster.chatbot_db.private_uri
  sensitive   = true
}

# Container Registry
output "registry_endpoint" {
  description = "Endpoint do Container Registry"
  value       = digitalocean_container_registry.chatbot_registry.endpoint
}

output "registry_server_url" {
  description = "URL do servidor do Container Registry"
  value       = digitalocean_container_registry.chatbot_registry.server_url
}

# Projeto
output "project_id" {
  description = "ID do projeto no DigitalOcean"
  value       = digitalocean_project.chatbot_project.id
}

# Domínio personalizado (se configurado)
output "custom_domain_status" {
  description = "Status do domínio personalizado"
  value       = var.custom_domain != "" ? "Configurado: ${var.custom_domain}" : "Não configurado"
}

# Réplica do banco (se habilitada)
output "database_replica_host" {
  description = "Host da réplica do banco de dados"
  value       = var.enable_database_replica ? digitalocean_database_replica.chatbot_db_replica[0].host : null
  sensitive   = true
}

# Resumo da configuração
output "deployment_summary" {
  description = "Resumo da configuração deployada"
  value = {
    project_name  = var.project_name
    environment   = var.environment
    region        = var.region
    app_instances = var.app_instance_count
    instance_size = var.app_instance_size
    database_size = var.database_size
    has_replica   = var.enable_database_replica
    custom_domain = var.custom_domain != "" ? var.custom_domain : "Não configurado"
    git_repo      = var.git_repo_url
    git_branch    = var.git_branch
  }
}
