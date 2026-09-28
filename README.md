# Azure App Service + VNet Integration + NSG (Terraform)

Proyecto de infraestructura como código para desplegar una aplicación Linux en Azure App Service integrada en una red virtual. El objetivo es demostrar redes Azure, una subred delegada para App Service, reglas de NSG y controles de seguridad básicos.

## Arquitectura

```text
Internet
   |
   v
Azure App Service (HTTPS)
   |
   | VNet Integration: tráfico saliente
   v
Subnet app-integration (10.20.1.0/26, delegated to Microsoft.Web/serverFarms)
   |
   +-- Network Security Group
         - Allow AzureCloud HTTPS outbound
         - Allow VirtualNetwork outbound
         - Deny other Internet outbound
```

> **Matiz importante:** VNet Integration permite que App Service haga llamadas **de salida** por la VNet. Las reglas inbound del NSG no controlan el acceso público a la web. Para controlar entrada se usan App Service Access Restrictions o un Private Endpoint. Consulta la [documentación de Microsoft](https://learn.microsoft.com/azure/app-service/overview-vnet-integration).

## Recursos creados

- Resource Group
- Virtual Network y subred dedicada `/26`
- Delegación `Microsoft.Web/serverFarms`
- Network Security Group y asociación a la subred
- Linux App Service Plan (SKU B1 por defecto)
- Linux Web App con HTTPS obligatorio y autenticación básica de FTP/WebDeploy desactivada
- Identidad administrada asignada por el sistema
- Integración regional con la subred y `vnet_route_all_enabled = true`

## Requisitos

- Suscripción Azure con permisos para crear recursos y asociar la aplicación a una subred.
- Azure CLI autenticado: `az login`.
- Terraform 1.6 o superior.

## Despliegue

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
# Cambia web_app_name por un nombre único globalmente.

terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

Cuando termines la práctica, elimina los recursos:

```powershell
terraform destroy -var-file="terraform.tfvars"
```

## Decisiones de diseño

### Subred dedicada y delegada

App Service VNet Integration requiere una subred dedicada que se delega a `Microsoft.Web/serverFarms`. Se usa `/26`, por encima del mínimo, para dejar margen durante escalados y actualizaciones de plataforma.

### NSG para salida, no para entrada

Con `vnet_route_all_enabled = true`, el tráfico saliente de la app se envía a la VNet y puede evaluarse con el NSG. Las reglas permiten HTTPS a `AzureCloud` y tráfico a la red virtual; el resto del tráfico de Internet queda denegado. En un entorno real se revisarían las dependencias concretas de la app antes de cerrar la salida.

### Seguridad del servicio web

La Web App exige HTTPS, desactiva la autenticación básica de publicación y usa una identidad administrada. La identidad evita depender de secretos estáticos si en el futuro se integra con Key Vault, Storage u otros servicios Azure.

## Coste y limpieza

El plan B1 puede generar coste. Revisa el plan antes de aplicarlo, usa una suscripción de laboratorio y ejecuta `terraform destroy` al terminar. La integración VNet no tiene cargo adicional, pero sí lo tiene el plan de App Service.

## Validación continua

El workflow en `.github/workflows/terraform.yml` ejecuta formato y validación de Terraform en cada pull request y push a `main`. No ejecuta `apply`: un despliegue automático requeriría identidad federada, permisos acotados y un proceso de aprobación.
