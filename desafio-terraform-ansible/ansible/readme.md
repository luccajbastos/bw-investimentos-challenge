
## Dependencias:
- ansible
- kubernetes
- botocore
- boto3

## O que é ansible-galaxy?
- É o gerenciador de pacotes do Ansible.
- Ele baixa coleções ou roles já prontas da comunidade e da RedHat (criadora do Ansible).
- Essas coleções são como “plugins” que adicionam módulos para interagir com serviços diferentes.

## O que é uma collection?
- Uma collection no Ansible é um pacote que contém:
    - Módulos (ações que você pode executar, ex: criar VPC, aplicar manifest no Kubernetes).
    - Roles (conjunto de boas práticas e tarefas agrupadas).
    - Plugins (filtros, inventários dinâmicos etc.).

## Comando:
- ansible-galaxy collection install amazon.aws community.kubernetes

###  Nesse comando específico:
- amazon.aws → coleção oficial da AWS. Permite usar módulos como ec2_instance, eks_cluster, s3_bucket, etc. É o que conecta o Ansible à AWS.

- community.kubernetes → coleção da comunidade para Kubernetes. Permite usar módulos como k8s (aplicar manifests), helm (instalar charts), k8s_info (listar objetos). É o que conecta o Ansible ao seu cluster EKS.

### Principais comandos

- Instalar uma coleção: ansible-galaxy collection install nome.da.collection
- Ver coleções já instaladas: ansible-galaxy collection list
- Atualizar uma coleção: ansible-galaxy collection install nome.da.collection --upgrade
- Remover: rm -rf ~/.ansible/collections/ansible_collections/nome/da/collection
- ansible-playbook -i localhost, ../playbook.yaml


### Links
- https://galaxy.ansible.com/ui/collections/
- https://artifacthub.io/packages/helm/apache-airflow/airflow?modal=values-schema&path=postgresql