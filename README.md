# 🚀 DevOps Assignment — Full Stack Application Deployment on AWS ECS Fargate

This project is a monorepo containing a containerized backend and frontend application deployed using AWS ECS Fargate. CI/CD is implemented with GitHub Actions, infrastructure is provisioned using Terraform, and monitoring/alerting is configured via CloudWatch.


## 📁 Project Structure

---
DevOps-Assignment/
├── backend/              # FastAPI backend with Docker and unit tests
│   ├── app/
│   ├── tests/
│   └── Dockerfile
│
├── frontend/             # Next.js frontend with Docker and E2E tests
│   ├── pages/
│   ├── __tests__/
│   └── Dockerfile
│
├── terraform/            # Terraform configs to provision AWS ECS, VPC, ALB, IAM
│   ├── main.tf
│   ├── variables.tf
│   └── ...
│
└── .github/
    └── workflows/        # GitHub Actions CI/CD pipelines for dev and main branches
        ├── ci.yml
        └── cd.yml


---

## 🛠️ Technologies Used

- **Frontend**: Next.js
- **Backend**: FastAPI (Python)
- **Infrastructure**: Terraform
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Cloud Provider**: AWS (ECS Fargate, ALB, ECR, CloudWatch)
- **Monitoring & Alerting**: CloudWatch + SNS

---

## ⚙️ Branching Strategy

- `main`: Production-ready code (triggers **CD**)
- `develop`: Development-ready code (triggers **CI**)
- `feature/*`: Feature-specific branches
- All code changes go through **pull requests** → merged to `develop` or `main` after review

---

## 🧪 Testing

### Backend (FastAPI)
- Unit tests using **pytest**
- `/api/health` and `/api/message` endpoints
- Dockerized app and test execution

### Frontend (Next.js)
- E2E tests using **Jest + React Testing Library**
- Calls backend API dynamically using `NEXT_PUBLIC_API_URL`

---

## 🐳 Dockerization

### Backend
- Multi-stage Dockerfile
- Image built and pushed to ECR via CI pipeline

### Frontend
- Production-ready Dockerfile for Next.js app
- Also built and pushed via CI

---

## 🔁 CI/CD Pipeline

### On Push to `develop`
- Runs backend + frontend tests
- Builds Docker images
- Tags with Git SHA
- Pushes to AWS ECR

### On Merge to `main`
- Triggers ECS service update (CD) to deploy latest images

---

## 🌐 Infrastructure Details (Terraform)

Provisioned using IaC:
- VPC, Subnets, Route Tables
- ALB (Application Load Balancer) with 2 target groups:
  - `/api/*` → backend
  - `/*` → frontend
- ECS Cluster (Fargate launch type)
- Task definitions for frontend & backend
- IAM roles with least privilege
- Security groups for ECS + ALB

---

## 📊 Monitoring & Alerting (CloudWatch)

- Container Insights enabled for ECS Fargate
- CloudWatch Dashboard showing:
  - CPU & memory usage
  - Request counts via ALB
- Alarm:
  - Triggered if **CPU > 70% for 5 minutes**
  - Sends notification via **SNS email**

---

## 🔐 Secrets & IAM

- Credentials managed securely via **GitHub Secrets**
- IAM roles follow **least privilege** principle
- No use of AWS Secrets Manager (by design choice)

---

## 🌐 Accessing the Application

Once deployed:
- **Frontend**: `http://devops-alb-1451775341.us-east-1.elb.amazonaws.com`
- **Backend Api Message**: `http://devops-alb-1451775341.us-east-1.elb.amazonaws.com/api/message`

---

## 📝 Setup Instructions

### 🧪 Run Locally

#### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
````

#### Frontend

```bash
cd frontend
cp .env.local.example .env.local
# Set backend API URL
npm install
npm run dev
```

### ☁️ Deploy Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```

## 👤 Author

**Jawaid Akhtar**
📧 [LinkedIn](https://linkedin.com/in/jawaid-akhtar)
🐙 [GitHub](https://github.com/JawaidAkhtar)

