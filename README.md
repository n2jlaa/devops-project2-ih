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

✅ Terraform will create:
- Resource Group  
- VNet + Subnets  
- ACI containers  
- Application Gateway (WAF)  
- Azure SQL Database  
- Application Insights  

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
