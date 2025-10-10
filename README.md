# 🌐 **Project 2 — Secure & Scalable 3-Tier Web App on Azure**

This project deploys a complete **3-tier architecture (Frontend + Backend + Database)** on **Azure Cloud** using:
- 🧱 **Terraform** for Infrastructure-as-Code (IaC)
- 📦 **Azure Container Registry (ACR)** to store Docker images
- 🐳 **Azure Container Instances (ACI)** to run containers
- 🌐 **Azure Application Gateway (WAF v2)** for secure routing
- 🗄️ **Azure SQL Database** as the data tier

---

## 🏗️ **Architecture Overview**

| Tier | Service | Description |
|------|----------|-------------|
| Frontend | Azure Container Instance | Node.js app exposed on port 80 |
| Backend | Azure Container Instance | Spring Boot app exposed on port 8080 |
| Database | Azure SQL Database | Managed SQL service |
| Gateway | Application Gateway (WAF v2) | Routes `/` → frontend, `/api/*` → backend |
| Registry | Azure Container Registry | Stores Docker images |
| Monitoring | Application Insights | Tracks app metrics & logs |

### **Azure Networking**
- **VNet:** `project2-najla-vnet`
- **Subnets:**
  - `aci-frontend-subnet`
  - `aci-backend-subnet`
  - `appgw-subnet`
- **Security:** Backend NSG allows inbound only from Application Gateway subnet.

---

## ⚙️ **Deployment Steps**

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/n2jlaa/devops-project2-ih.git
cd devops-project2-ih
```

---

### **2️⃣ Build & Push Docker Images to ACR**
Build the images directly on **Azure Cloud** (not locally):

```bash
# Build backend image
az acr build -r najlaacr123 -t backend:latest ./backend

# Build frontend image
az acr build -r najlaacr123 -t frontend:latest ./frontend
```

Verify uploaded images:
```bash
az acr repository list -n najlaacr123 -o table
az acr repository show-tags -n najlaacr123 --repository backend -o table
az acr repository show-tags -n najlaacr123 --repository frontend -o table
```

---

### **3️⃣ Deploy Infrastructure with Terraform**
From the `infra/terraform` directory:
```bash
cd infra/terraform
terraform init
terraform apply -auto-approve
```

✅ Terraform will create:
- Resource Group  
- VNet + Subnets  
- ACI containers  
- Application Gateway (WAF)  
- Azure SQL Database  
- Application Insights  

Example Output:
```bash
Apply complete! Resources: 6 added, 3 changed, 2 destroyed.

Outputs:
appgw_public_ip = "172.213.216.138"
sql_server_fqdn = "najlasqlserver.database.windows.net"
```

---

### **4️⃣ Verify Containers**
```bash
az container show -g project2-najla -n aci-frontend --query "containers[0].image" -o tsv
az container show -g project2-najla -n aci-backend  --query "containers[0].image" -o tsv
```

✅ Output should show:
```
najlaacr123.azurecr.io/frontend:latest
najlaacr123.azurecr.io/backend:latest
```

If needed:
```bash
az container restart -g project2-najla -n aci-frontend
az container restart -g project2-najla -n aci-backend
```

---

### **5️⃣ Check Application Gateway Health**
Azure Portal → Application Gateway → **Backend Health**

| Pool | Port | Status |
|-------|------|--------|
| pool-frontend-aci | 80 | ✅ Healthy |
| pool-backend-aci | 8080 | ✅ Healthy |

> If backend shows **Unhealthy**, check your health probe path (`/actuator/health` or `/`) and reapply Terraform:
```bash
terraform apply -auto-approve
```

---

### **6️⃣ Access the Application**
Open browser:
```
Frontend → http://172.213.216.138/
Backend → http://172.213.216.138/api/...
```

Or test directly:
```bash
curl -i http://172.213.216.138/api/health
```

---

## 🧠 **Terraform Variables Example**
```hcl
location        = "italynorth"
resource_prefix = "project2-najla"

# Frontend
fe_container_port = 80
fe_health_path    = "/"

# Backend
be_container_port = 8080
be_health_path    = "/actuator/health"
```

---

## 🔒 **Security**
- ACR authentication via Managed Identity  
- Backend NSG allows traffic **only** from Application Gateway subnet  
- SQL access limited to **private endpoint only**  
- No public access to compute or DB  

---

## 📊 **Monitoring**
- Application Insights connected to ACI  
- Logs & metrics viewable in Azure Portal  
- Health probes check availability every 30 seconds  

---

## 🖼️ **Screenshots to Include in Report**
✅ Terraform Apply complete  
✅ Application Gateway Health (both Healthy)  
✅ ACR repositories (backend & frontend)  
✅ ACI containers running  
✅ Browser frontend access  

---

## ✅ **Project Summary**

| Task | Status |
|------|--------|
| Terraform Infrastructure | ✅ Done |
| ACR Images | ✅ Built & Pushed |
| ACI Containers | ✅ Running |
| App Gateway | ✅ Configured |
| Health Probes | ✅ Healthy |
| Monitoring | ✅ Active |

---

### 👩‍💻 **Author**
**Najlaa Alahmari**  
DevOps Engineer | Azure | Terraform | Docker | GitHub Actions  

---

### 🧾 **Full Command Reference (Quick Run Recap)**
```bash
# Clone project
git clone https://github.com/n2jlaa/devops-project2-ih.git
cd devops-project2-ih

# Build & Push images to ACR
az acr build -r najlaacr123 -t backend:latest ./backend
az acr build -r najlaacr123 -t frontend:latest ./frontend

# Deploy Infra
cd infra/terraform
terraform init
terraform apply -auto-approve

# Verify ACI containers
az container show -g project2-najla -n aci-frontend --query "containers[0].image" -o tsv
az container show -g project2-najla -n aci-backend --query "containers[0].image" -o tsv

# Restart containers (if needed)
az container restart -g project2-najla -n aci-frontend
az container restart -g project2-najla -n aci-backend

# Access Application
http://172.213.216.138/
http://172.213.216.138/api/health

```
---
