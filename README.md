# Desafio Técnico DevOps — Documentação Técnica

## Objetivo
Criar um ambiente Apache Airflow na AWS usando Terraform para provisionamento da infraestrutura e Ansible para provisionamento e deploy do Airflow. O ambiente deve ser reproduzível, auditável e seguro suficiente para avaliação técnica por time de infra.

Versão do Airflow requerida: `2.10.5` com `Python 3.9` (usar imagem oficial do Docker Hub).

## 1. Escopo
- Provisionar infra na AWS via Terraform: VPC, subnets, ALB, EKS (cluster), node groups, IAM, S3 (artefatos e estado de terraform).
- Provisionar release do Airflow no EKS via Ansible (helm charts) usando a imagem `apache/airflow:2.10.5-python3.9`.  
- Expor o Webserver através de Application Load Balancer (ALB).  


## 2. Arquitetura

### 2.1 Arquitetura AWS (visão geral)
![(Imagem: `assets/AWS.jpg`)](assets/AWS.jpg)

Componentes principais:
- VPC com subnets públicas e privadas.  
- Internet Gateway + NAT Gateways (para subnets privadas, se necessário).  
- Application Load Balancer na camada pública para tráfego HTTP ao Webserver.  
- EKS Cluster (control plane gerenciado pela AWS).  
- Managed Node Groups para workloads.  
- IAM Roles: cluster role, node role, IRSA para pods acessarem AWS APIs.  

### 2.2 Arquitetura Kubernetes
![(Imagem: `assets/K8S.jpg`)](assets/K8S.jpg)

Componentes:
- Ingress Controller: AWS Load Balancer Controller (ALB ingress) para integrar ALB ao Kubernetes.  
- Helm releases: Airflow chart.  
- Pods Airflow: webserver, scheduler, workers, triggerer, migrations, sync.  
- Banco de metadados: Postgres (sem persistência).  

## 3. Ansible

Pontos principais
- Idempotência com módulos community.kubernetes.helm ou kubernetes.core.helm.

Comandos
- ansible-playbook -i localhost, playbook.yml

## 4. Execução do desafio

### Pré-requisitos
- AWS CLI configurado.
- Terraform >= 1.X.
- Ansible >= 2.11 com collections community.kubernetes, kubernetes.core.
- kubectl e helm instalados.

### Passo-a-passo
- Colar as credenciais da AWS no terminal ou criar um profile com um IAM User
- terraform init
- terraform plan -var-file=default.tfvars
- terraform apply -var-file=default.tfvars
- (Mudar variáveis de Subnet e Cluster name no Playbook)
- ansible-playbook -i localhost, playbook.yml

# Desafio de Programação — Conciliação de Transações Financeiras

## Objetivo
Escrever uma função `reconcile_accounts` que realize a conciliação (ou batimento) entre dois grupos de transações financeiras.  

A função deve comparar duas listas de transações e indicar se cada transação foi encontrada (`FOUND`) ou não (`MISSING`) na outra lista, considerando duplicatas e pequenas variações de data (dia anterior ou posterior).

---

## Regras do desafio

### Entrada
- Duas listas de listas (`transactions1` e `transactions2`), representando linhas de dados financeiros.  
- Cada linha tem quatro colunas (todas como **strings**):
  1. **Data**: `YYYY-MM-DD`
  2. **Departamento**
  3. **Valor**
  4. **Beneficiário`

## Regras de correspondência
- Cada transação de uma lista deve corresponder a no máximo uma transação da outra lista.
- Pode haver transações duplicadas; cada correspondência é única.
- A data da transação pode ser do dia anterior, igual ou do dia seguinte, desde que os demais campos coincidam.
- Se houver múltiplas correspondências possíveis, a transação deve se ligar à que ocorre mais cedo.

# Como rodar
```shell
conda create -y -n myenv python=3.9
conda activate myenv
python3 main.py
```

