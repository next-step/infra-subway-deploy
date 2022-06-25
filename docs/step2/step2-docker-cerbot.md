```shell script
docker run -it --rm --name certbot \
  -v '/etc/letsencrypt:/etc/letsencrypt' \
  -v '/var/lib/letsencrypt:/var/lib/letsencrypt' \
  certbot/certbot certonly -d 'choiys-wootech.kro.kr' --manual --preferred-challenges dns --server https://acme-v02.api.letsencrypt.org/directory
```

