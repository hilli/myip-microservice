# myip-microservice

Simple little service to return the best know IP address of the requester. It will return a json object if `application/json` is reqiested by the client, otherwise only the IP is returned as `text/plain`.

## Running

### Docker command

```
docker run -i -t --rm -p 80:8080 hilli/myip-microservice
```