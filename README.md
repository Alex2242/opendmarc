# Docker image for OpenDMARC

## Usage

The simplest way to run the image is:
```bash
$ docker run -d -p 8893:8893 alex2242/opendmarc:latest
```

Be sure that a firewall is blocking remote access to the port `8893`.

Using docker-compose is recommended especially if the process using OpenDMARC
is running with Docker.

Here is a template for docker-compose:

```yaml
version: '3.6'

services:
  opendmarc:
    image: alex2242/opendmarc:latest
    container_name: opendmarc
    volumes:
      - /local/path/opendmarc.conf:/etc/opendmarc/opendmarc.conf:ro
      # /var/run/opendmarc can be mounted on the host in order to access
      # lgos easily
      - /local/path/data:/var/run/opendmarc
    netwoks:
      - dmarc_net

networks:
  dmarc_net:
```

OpenDMARC is not exposed, the service that requires OpenDMARC to `dmarc_net`.

## Configuration

The default configuration provides a OpenDMARC service by exposing the port
`8893` but doesn't provide configuration. The configuration file
(`/etc/opendmarc/opendmarc.conf`) should be modified if sending reports is needed.
