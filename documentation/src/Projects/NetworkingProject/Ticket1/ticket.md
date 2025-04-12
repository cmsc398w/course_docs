# Ticket 1: Unable to access internal CRM system

Description:
Since this morning, our sales team can't access the CRM system at <http://crm.internal.company> (10.0.0.50). When trying to access it, the page just keeps loading forever. What's strange is that we can still successfully ping the server, and the IT team confirms the CRM application is running. This is affecting our entire sales floor of 20 people.

Additional Notes:

- CRM runs on port 8080
- We can ping the server successfully
- Other internal websites are working fine
- No recent network changes according to IT

## Steps To Reproduce

From the Ticket1/ directory:

```bash
# builds the docker file
docker compose build

# runs the docker containers
docker compose up -d
```

This mock setup has two "servers" (each is their own docker container), the `sales-client` and the `crm-server`. The sales team is using the `sales-client` and the CRM server is hosted on `crm-server` using ngix (if you don't know what this is, don't worry or look it up). If you're curious, the client uses the `alpine:edge` image and the `nginx:alpine-slim` image, but each one will have the tools you need to complete the project.

### To start the `sales-client`

```bash
docker exec -it sales-client sh 
```

This will allow you to use an interactive shell as if you were SSHed into the server. Note that this isn't the bash shell but sh, which is similar but may not be exactly the same.

You can simply use the `exit` command to leave.

### To start the 'crm-server:

```bash
docker exec -it crm-server sh 
```

### Cleanup

```bash
docker-compose stop
docker-compose down
```

## Hint

Is the server listening on the right interfaces?