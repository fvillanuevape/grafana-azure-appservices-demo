# Introducción
TODO: Implementación de grafana en App Services.

# Infraestructura
- Azure App Services
- Azure Mariadb
- Azure Container Registry
- Azure Log Analytics es opcional, pero en este caso Grafana hará consulta de Logs de Log Analytics.
- Azure AD para autenticar a los usuarios para el ingreso al portal de Grafana.

# Ejecución localmente
````
docker run -d \
-p 3000:3000 \
--name=grafana-demo \
-e "GRAFANA_DATABASE_TYPE=mysql" \
-e "GRAFANA_DATABASE_HOST=your-database-on-azure" \
-e "GRAFANA_DATABASE_NAME=grafana" \
-e "GRAFANA_DATABASE_USER=your-database-user" \
-e "GRAFANA_DATABASE_PASSWORD=your-database-password" \
grafana-prima:latest
````
# Build Azure ACR
````
ACR_NAME=registryfiztecdev01
az acr build --registry $ACR_NAME --resource-group rg-grafana-dev --image grafana-demo:latest .
````


# Creación de la base de datos y el usuario
````
CREATE DATABASE grafana;
CREATE USER 'grafanausr'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON grafana . * TO 'grafanausr'@'%';
FLUSH PRIVILEGES;
