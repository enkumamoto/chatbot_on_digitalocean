# Infraestrutura Terraform para Chatbot no DigitalOcean

Este projeto provisiona uma infraestrutura completa no DigitalOcean App Platform para hospedar um chatbot, incluindo banco de dados PostgreSQL, container registry e configurações de domínio personalizado.

## 🚀 Recursos Provisionados

- **App Platform**: Aplicação principal do chatbot com auto-scaling
- **PostgreSQL Database**: Banco de dados gerenciado com backups automáticos
- **Container Registry**: Para armazenar imagens Docker
- **Worker Process**: Para processamento em background
- **Database Migration Job**: Para executar migrações automaticamente
- **SSL Certificate**: Certificado Let's Encrypt para domínio personalizado
- **Project Organization**: Organização de recursos em projeto dedicado
- **Monitoring & Alerts**: Alertas de deployment e domínio

## 📋 Pré-requisitos

1. **Terraform** instalado (versão 1.0+)
2. **Token de API do DigitalOcean** com permissões de escrita
3. **Repositório Git** com código do chatbot
4. **Domínio próprio** (opcional, para domínio personalizado)

## 🛠️ Como Usar

### 1. Clone e Configure

```bash
# Clone este repositório
git clone <este-repositorio>
cd chatbot-digitalocean-terraform

# Copie o arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars
```

### 2. Configure as Variáveis

Edite o arquivo `terraform.tfvars` com suas configurações:

```hcl
# Token obrigatório
digitalocean_token = "dop_v1_seu_token_aqui"

# Configurações do projeto
project_name = "meu-chatbot"
environment  = "production"

# Repositório do seu chatbot
git_repo_url = "https://github.com/seu-usuario/seu-chatbot.git"
git_branch   = "main"

# Domínio personalizado (opcional)
custom_domain = "chatbot.seudominio.com"
```

### 3. Deploy da Infraestrutura

```bash
# Inicializar Terraform
terraform init

# Planejar mudanças
terraform plan

# Aplicar configurações
terraform apply
```

### 4. Verificar Deployment

Após o deployment, você receberá outputs com:

- URL da aplicação
- Informações do banco de dados
- Status do domínio personalizado

## 🔧 Configurações Disponíveis

### Tamanhos de Instância App Platform

- `basic-xxs`: 0.5 vCPU, 0.5GB RAM
- `basic-xs`: 1 vCPU, 1GB RAM
- `basic-s`: 1 vCPU, 2GB RAM
- `professional-xs`: 1 vCPU, 2GB RAM
- `professional-s`: 2 vCPU, 4GB RAM

### Tamanhos de Banco de Dados

- `db-s-1vcpu-1gb`: 1 vCPU, 1GB RAM
- `db-s-1vcpu-2gb`: 1 vCPU, 2GB RAM
- `db-s-2vcpu-4gb`: 2 vCPU, 4GB RAM

### Regiões Disponíveis

- `nyc1`, `nyc3`: Nova York
- `sfo3`: São Francisco
- `ams3`: Amsterdam
- `sgp1`: Singapura
- `lon1`: Londres
- `fra1`: Frankfurt
- `tor1`: Toronto
- `blr1`: Bangalore

## 📊 Monitoramento

O Terraform configura automaticamente:

- Alertas de falha de deployment
- Alertas de problema com domínio
- Health checks HTTP na rota `/health`
- Logs centralizados no DigitalOcean

## 🔐 Segurança

- Variáveis sensíveis marcadas como `sensitive`
- Firewall do banco configurado para aceitar apenas o app
- Certificados SSL automáticos via Let's Encrypt
- Conexões privadas entre app e banco de dados

## 💰 Custos Estimados

Para configuração básica (production-ready):

- App Platform (basic-xxs): ~$5/mês
- PostgreSQL (db-s-1vcpu-1gb): ~$15/mês
- Container Registry (basic): ~$5/mês
- **Total estimado**: ~$25/mês

## 🚨 Troubleshooting

### Erro de Token

```
Error: Unable to authenticate with DigitalOcean API
```

Verifique se o token está correto e tem permissões adequadas.

### Falha no Deployment

```
Error: App deployment failed
```

Verifique se o repositório Git está acessível e tem um Dockerfile ou buildpack compatível.

### Problema com Domínio

```
Error: Domain validation failed
```

Certifique-se de que o domínio aponta para os nameservers do DigitalOcean.

## 🔄 Comandos Úteis

```bash
# Ver estado atual
terraform show

# Ver outputs
terraform output

# Atualizar apenas um recurso
terraform apply -target=digitalocean_app.chatbot_app

# Destruir infraestrutura
terraform destroy
```

## 📚 Requisitos do Código do Chatbot

Seu repositório deve conter:

1. **Dockerfile** ou ser compatível com buildpacks
2. **Porta 8080** para HTTP
3. **Endpoint `/health`** para health checks
4. **Variável `DATABASE_URL`** para conexão com PostgreSQL
5. **Comando `npm run db:migrate`** para migrações (se usando Node.js)

Exemplo de estrutura básica:

```
seu-chatbot/
├── Dockerfile
├── package.json
├── src/
│   ├── index.js
│   └── health.js
└── migrations/
    └── init.sql
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.
