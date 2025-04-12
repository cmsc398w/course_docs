Subject: API Service Unreachable on New Network

Description:
Our development team just moved to a new office and can't reach the API service at 10.0.0.75:3000. When trying to connect, the requests fail instantly with "Network is unreachable". Other services are working fine.

Additional Notes:
- Team moved to new subnet today
- API server hasn't changed
- Can't even ping the API server
- Other web services (like github.com) work fine

## Steps To Reproduce

From the Ticket3/ directory:

```bash
# builds the docker file, only need to do this one time
docker compose build

# runs the docker containers
docker compose up -d
```

### To enter the `api-server`

```bash
docker exec -it api-server sh 
```

This will allow you to use an interactive shell as if you were SSHed into the server. Note that this isn't the bash shell but sh, which is similar but may not be exactly the same.

You can simply use the `exit` command to leave.

### To enter the `client`:

```bash
docker exec -it client sh 
```

### Cleanup

```bash
docker-compose stop
docker-compose down
```