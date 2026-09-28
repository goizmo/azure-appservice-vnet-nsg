# Why this architecture

## What this project proves

This project focuses on the relationship between an Azure PaaS web application and networking controls:

1. A Linux Web App needs an App Service Plan to provide compute capacity.
2. Regional VNet Integration gives the app an interface in a dedicated delegated subnet for outbound calls.
3. An NSG associated with that subnet evaluates routed outbound traffic.
4. Enabling `vnet_route_all_enabled` means outbound application traffic is routed through the VNet, making the NSG policy meaningful.

## Important limitation

VNet Integration is not inbound private access. An inbound NSG rule does not protect the public App Service endpoint. Use one of these approaches when inbound protection is needed:

- App Service Access Restrictions for allow/deny rules on the public endpoint.
- A Private Endpoint plus DNS configuration to keep access private.
- An application gateway or front door design when appropriate.

## Why not deploy automatically from GitHub Actions?

The workflow validates Terraform only. A secure automatic deployment would normally use GitHub-to-Azure workload identity federation, a scoped Azure role, remote state, protected environments, and approval before production. Keeping `apply` out of the starter project avoids encouraging credential storage in a public repository.
