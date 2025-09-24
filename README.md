# Blue-Green Genesis

A containerised URL shortener application deployed on AWS ECS with blue-green deployment strategy. The deployment process is fully automated using a **CI/CD pipeline** that handles Docker image building, vulnerability scanning, and deployment to **different AWS environments** with seperate backend state files.

## Key Features

- **ECS** - Serverless container orchestration with Fargate
- **CodeDeploy** - Automated blue-green deployment orchestration
- **DynamoDB** - NoSQL database, utilised by the App, used for URL storage with TTL
- **CloudWatch** - Monitoring, logging, and observability for the App and WAF
- **VPC Endpoints** - Secure internal connectivity to AWS services
- **Route53** - DNS management and SSL certificate automation
- **WAF** - Web application firewall protection which sits in front of the ALB
- **ALB** - Application Load Balancer for traffic routing
- **Multi-Environment Backends** - Separate Terraform state files for dev and prod AWS environments

<br>

## Architecture

![AD](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/Architecture-Diagram.png)


<br>

## Directory Structure

```
./
├── app/
│   ├── finalgreen/          # Production app version
│   └── initialblue/         # Initial app version
├── deployment/
│   └── appspectemplate.yml  # CodeDeploy configuration
├── terraform/
│   ├── environments/        # Dev/Prod configurations
│   └── modules/             # Infrastructure modules
└── .github/workflows/       # CI/CD pipelines
```

<br>

## Setup Instructions

<br>

### Configuration Steps

**Before deployment, configure the following:**

1. **Create ECR Private Registry**
   - Go to AWS Console → ECR → Create repository
   - Repository name: `url-shortener`
   - Make it private
   - Note down the repository URI (e.g., `123456789012.dkr.ecr.eu-west-2.amazonaws.com/url-shortener`)

2. **Update Terraform Variables**
   - Edit `terraform/environments/dev/variables.tf` and `terraform/environments/prod/variables.tf`:
        - Update `ecs_container_image` with your InitialBlue ECR registry address
        - Update `domain_name` with your domain name
   - Example: `123456789012.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:initialblue` (you will know this value after you have built and pushed your initialblue image through the cicd pipeline below)
   - Example: `your-domain.com`

3. **Configure GitHub Actions Variables**
   - Go to GitHub repository → Settings → Secrets and variables → Actions → Variables tab
   - Add the following variables:
     - `AWS_GITHUB_ROLE_ARN`: Your GitHub Actions IAM role ARN (e.g., `arn:aws:iam::123456789012:role/github-cicd-role`)
     - `ECR_REGISTRY`: Your ECR registry URL (e.g., `<123456789012>.dkr.ecr.eu-west-2.amazonaws.com`)

<br>

### Deployment Steps

**Important**: Follow this exact sequence for proper deployment:

1. **Build and Push InitialBlue Image**
   - Go to GitHub Actions → Docker Build & Push → Run workflow
        - Choose "InitialBlue" image
        - This creates the initial version of the app

2. **Deploy Infrastructure**
   - Go to GitHub Actions → Terraform Plan → Run workflow
        - **Choose one environment** (`dev` or `prod`) and stick with it throughout the deployment
        - **Review the plan** to ensure everything looks correct
   - Go to GitHub Actions → Terraform Apply → Run workflow
        - **Choose the same environment** that you chose in the Terraform Plan above
        - This sets up the AWS Infrastructure, including ECS service with the InitialBlue image

3. **Build and Push FinalGreen Image**
   - Go to GitHub Actions → Docker Build & Push → Run workflow
        - Choose "FinalGreen" image
        - This creates the production-ready version of the app with all features

4. **Blue-Green Deployment**
   - Create new ECS task definition with the FinalGreen ECR image digest
   - Use AWS CodeDeploy with the AppSpec template (`deployment/appspectemplate.yml`)
   - Traffic automatically shifts from blue to green environment, with rollback on health check failures

5. **Destroy Infrastructure**
   - Go to GitHub Actions → Terraform Destroy → Run workflow
        - **Choose the same environment** used for deployment
        - This will clean up all AWS resources created by Terraform


<br>

## How to Use the App

### App Version Differences

- **InitialBlue**: Basic URL shortening functionality
- **FinalGreen**: Full-featured version with modern UI

### Web Interface

Access the application through your Route 53 domain to use the web interface for URL shortening.

**Note**: Modern UI is only available in FinalGreen version.

<br>

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

<br>

|Here's what it will look like:|
|-------|
|InitialBlue App:|
| ![Blue App](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/Blue-App.png) |
|FinalGreen App:|
| ![Green App](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/Green-App.png) |
|FinalGreen App Health Check:|
| ![Green App Health](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/Green-App-Health.png) |
|CodeDeploy Deployment Start:|
| ![CodeDeploy Start](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/CodeDeploy-Startup.png) |
|CodeDeploy Deployment Complete:|
| ![CodeDeploy Finish](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/CodeDeploy-Finish.png) |
|WAF Configuration:|
| ![WAF](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/WAF.png) |
|VPC Endpoints:|
| ![VPC Endpoints](https://raw.githubusercontent.com/JunedConnect/project-url-shortener/main/images/VPC-Endpoints.png) |