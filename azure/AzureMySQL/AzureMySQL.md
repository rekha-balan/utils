- Resource group (se serve)
		
		az group create \
		--name unito-test-rg \
		--location westeurope

- Creazione db

		az mysql server create \
		--resource-group unito-test-rg \
		--name unito-test-db1 \
		--location westeurope \
		--admin-user unito \
		--admin-password ADMINPASSWORD \
		--performance-tier Basic \
		--compute-units 50
		
- Regole firewall

		az mysql server firewall-rule create \
		--resource-group unito-test-rg \
		--server unito-test-db1 \
		--name UnitoSistemi \
		--start-ip-address 192.168.0.1 \
		--end-ip-address 192.168.0.10

- Get connection informations

		az mysql server show \
		--resource-group unito-test-rg \
		--name unito-test-db1