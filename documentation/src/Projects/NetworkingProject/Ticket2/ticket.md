# Ticket 2: Cannot access company blog from certain locations

Priority: High
Customer: Marketing Department
Subject: Cannot access company blog from certain locations

Description:
Our company blog (blog.company.internal) is not accessible from our new office location, but works fine from headquarters. When trying to access the blog, browsers show "Could not resolve host". Other websites work fine from the new office. The blog server is running at 10.0.0.100 and the DNS server is on 10.0.0.53.

Additional Notes:

- Blog uses standard HTTP (port 80)
- Other internal websites (.company.internal domain) also fail from new office
- External websites (like google.com) work fine
- New office network: 10.0.0.0/24

## Steps To Reproduce

From the Ticket2/ directory:

```bash
# builds the docker file
docker compose build

# runs the docker containers
docker compose up -d
```

### To start the `blog-server`

```bash
docker exec -it blog-server sh 
```

This will allow you to use an interactive shell as if you were SSHed into the server. Note that this isn't the bash shell but sh, which is similar but may not be exactly the same.

You can simply use the `exit` command to leave.

### To start the `client`:

```bash
docker exec -it client sh 
```

### Cleanup

```bash
docker-compose stop
docker-compose down
```
