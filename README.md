# URL Shortener ECS

A containerised URL shortener application deployed on AWS ECS with blue-green deployment strategy.

---

## Key Features

- **AWS ECS** - Serverless container orchestration with Fargate
- **AWS WAF** - Web application firewall protection
- **AWS Route53** - DNS management and SSL certificate automation
- **AWS ALB** - Application Load Balancer for traffic routing
- **DynamoDB** - NoSQL database, utilised by the App, used for URL storage with TTL
- **VPC Endpoints** - Secure connectivity to AWS services

---

## Architecture

```
Internet → Route 53 → ALB → ECS Service (Blue/Green) → DynamoDB
                    ↓
                  WAF Protection
```

### Directory Structure

```
./
├── app/
│   ├── finalgreen/          # Production app version
│   └── initialblue/         # Initial app version
├── deployment/
│   └── appspectemplate.yml  # CodeDeploy configuration
├── terraform/
│   ├── environments/        # Dev/Prod configurations
│   └── modules/            # Infrastructure modules
└── .github/workflows/      # CI/CD pipelines
```

---

## Setup Instructions

<br>

### Configuration Steps

**Before deployment, configure the following:**

1. **Update Terraform Variables**
   - Edit `terraform/environments/dev/variables.tf` and `terraform/environments/prod/variables.tf`:
        - Update `ecs_container_image` with your InitialBlue ECR registry address
        - Update `domain_name` with your domain name
   - Example: `123456789012.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:initialblue` (you will know this value after you have built and pushed your initialblue image through the cicd pipeline)
   - Example: `your-domain.com`

2. **Configure GitHub Actions Variables**
   - Go to GitHub repository → Settings → Secrets and variables → Actions → Variables tab
   - Add the following variables:
     - `AWS_GITHUB_ROLE_ARN`: Your GitHub Actions IAM role ARN (e.g., `arn:aws:iam::ACCOUNT:role/github-cicd-role`)
     - `ECR_REGISTRY`: Your ECR registry URL (e.g., `123456789012.dkr.ecr.eu-west-2.amazonaws.com`)

<br>

### Deployment Steps

**Important**: Follow this exact sequence for proper deployment:

1. **Build and Push InitialBlue Image**
   - Go to GitHub Actions → Docker Build & Push → Run workflow
        - Choose "InitialBlue" image
   - This creates the initial version of the app

2. **Deploy Infrastructure**
     **Choose one environment** (`dev` or `prod`) and stick with it throughout the deployment
   - Go to GitHub Actions → Terraform Plan → Run workflow
        - **Review the plan** to ensure everything looks correct
   - Go to GitHub Actions → Terraform Apply → Run workflow
        - This sets up the AWS Infrastructure, including ECS service with the InitialBlue image

3. **Build and Push FinalGreen Image**
   - Go to GitHub Actions → Docker Build & Push → Run workflow
        - Choose "FinalGreen" image
   - This creates the production-ready version with all features

4. **Blue-Green Deployment**
   - Create new ECS task definition with the FinalGreen ECR image digest
   - Use AWS CodeDeploy with the AppSpec template (`deployment/appspectemplate.yml`)
   - Traffic automatically shifts from blue to green environment, with rollback on health check failures

5. **Destroy Infrastructure**
     **Choose the same environment** used for deployment
   - Go to GitHub Actions → Terraform Destroy → Run workflow
   - This will clean up all AWS resources created by Terraform

---

## How to Use the App

<br>

### App Version Differences

- **InitialBlue**: Basic URL shortening functionality
- **FinalGreen**: Full-featured version with modern UI

### Web Interface

Access the application through your Route 53 domain to use the web interface for URL shortening.

**Note**: Modern UI is only available in FinalGreen version.

### API Endpoints

**Shorten a URL** (Available in both versions)
```bash
curl -X POST "https://your-domain.com/shorten" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com/very/long/url"}'
```

**Bulk URL Shortening** (FinalGreen only)
```bash
curl -X POST "https://your-domain.com/bulk-shorten" \
  -H "Content-Type: application/json" \
  -d '{"urls": ["https://example.com/url1", "https://example.com/url2"]}'
```

**Get URL Statistics** (FinalGreen only)
```bash
curl "https://your-domain.com/stats/{short_id}"
```

**Redirect to Original URL** (Available in both versions)
```bash
curl "https://your-domain.com/{short_id}"
```

**Health Check** (Available in both versions)
```bash
curl "https://your-domain.com/healthz"
```

### Response Examples

**Shorten Response:**
```json
{
  "short": "a1b2c3d4",
  "url": "https://example.com/very/long/url",
  "created_at": 1640995200,
  "ttl": 1641081600
}
```

**Stats Response:**
```json
{
  "id": "a1b2c3d4",
  "url": "https://example.com/very/long/url",
  "created_at": 1640995200,
  "ttl": 1641081600,
  "hits": 42
}
```

---