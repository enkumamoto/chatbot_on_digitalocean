# Database PostgreSQL gerenciado para o chatbot
resource "digitalocean_database_cluster" "chatbot_db" {
  name       = "${var.project_name}-chatbot-db"
  engine     = "pg"
  version    = "15"
  size       = var.database_size
  region     = var.region
  node_count = 1

  tags = [
    "environment:${var.environment}",
    "project:${var.project_name}",
    "type:database"
  ]
}

# Firewall para o banco de dados
resource "digitalocean_database_firewall" "chatbot_db_firewall" {
  cluster_id = digitalocean_database_cluster.chatbot_db.id

  rule {
    type  = "app"
    value = digitalocean_app.chatbot_app.id
  }
}

# Container Registry para armazenar imagens Docker
resource "digitalocean_container_registry" "chatbot_registry" {
  name                   = "${var.project_name}-registry"
  subscription_tier_slug = "basic"
  region                 = var.region
}

# App Platform para hospedar o chatbot
resource "digitalocean_app" "chatbot_app" {
  spec {
    name   = "${var.project_name}-chatbot"
    region = var.region

    # Serviço principal do chatbot
    service {
      name               = "chatbot-service"
      environment_slug   = var.environment_slug
      instance_count     = var.app_instance_count
      instance_size_slug = var.app_instance_size

      # Configuração do repositório Git ou Container Registry
      git {
        repo_clone_url = var.git_repo_url
        branch         = var.git_branch
      }

      # Variáveis de ambiente
      env {
        key   = "DATABASE_URL"
        value = digitalocean_database_cluster.chatbot_db.private_uri
        scope = "RUN_AND_BUILD_TIME"
        type  = "SECRET"
      }

      env {
        key   = "ENVIRONMENT"
        value = var.environment
        scope = "RUN_AND_BUILD_TIME"
      }

      env {
        key   = "APP_NAME"
        value = "${var.project_name}-chatbot"
        scope = "RUN_AND_BUILD_TIME"
      }

      env {
        key   = "PORT"
        value = "8080"
        scope = "RUN_AND_BUILD_TIME"
      }

      # Configurações de saúde
      http_port = 8080

      health_check {
        http_path             = "/health"
        initial_delay_seconds = 30
        period_seconds        = 10
        timeout_seconds       = 5
        success_threshold     = 1
        failure_threshold     = 3
      }
    }

    # Worker para processamento em background (opcional)
    worker {
      name               = "chatbot-worker"
      environment_slug   = var.environment_slug
      instance_count     = 1
      instance_size_slug = "basic-xxs"

      git {
        repo_clone_url = var.git_repo_url
        branch         = var.git_branch
      }

      env {
        key   = "DATABASE_URL"
        value = digitalocean_database_cluster.chatbot_db.private_uri
        scope = "RUN_AND_BUILD_TIME"
        type  = "SECRET"
      }

      env {
        key   = "WORKER_MODE"
        value = "true"
        scope = "RUN_AND_BUILD_TIME"
      }
    }

    # Job para migrações de banco de dados
    job {
      name               = "db-migrate"
      environment_slug   = var.environment_slug
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      kind               = "PRE_DEPLOY"

      git {
        repo_clone_url = var.git_repo_url
        branch         = var.git_branch
      }

      env {
        key   = "DATABASE_URL"
        value = digitalocean_database_cluster.chatbot_db.private_uri
        scope = "RUN_AND_BUILD_TIME"
        type  = "SECRET"
      }

      run_command = "npm run db:migrate"
    }

    # Domínio personalizado (opcional)
    dynamic "domain" {
      for_each = var.custom_domain != "" ? [1] : []
      content {
        name = var.custom_domain
        type = "PRIMARY"
      }
    }

    # Alertas e monitoramento
    alert {
      rule = "DEPLOYMENT_FAILED"
    }

    alert {
      rule = "DOMAIN_FAILED"
    }
  }
}

# Projeto para organizar recursos
resource "digitalocean_project" "chatbot_project" {
  name        = "${var.project_name}-project"
  description = "Projeto para infraestrutura do chatbot ${var.project_name}"
  purpose     = "Web Application"
  environment = var.environment

  resources = [
    digitalocean_app.chatbot_app.urn,
    digitalocean_database_cluster.chatbot_db.urn,
    digitalocean_container_registry.chatbot_registry.urn
  ]
}

# Certificado SSL para domínio personalizado
resource "digitalocean_certificate" "chatbot_cert" {
  count = var.custom_domain != "" ? 1 : 0

  name    = "${var.project_name}-cert"
  type    = "lets_encrypt"
  domains = [var.custom_domain]

  lifecycle {
    create_before_destroy = true
  }
}

# Backup automático do banco de dados
resource "digitalocean_database_replica" "chatbot_db_replica" {
  count      = var.enable_database_replica ? 1 : 0
  cluster_id = digitalocean_database_cluster.chatbot_db.id
  name       = "${var.project_name}-chatbot-db-replica"
  region     = var.replica_region
  size       = var.database_size

  tags = [
    "environment:${var.environment}",
    "project:${var.project_name}",
    "type:database-replica"
  ]
}
