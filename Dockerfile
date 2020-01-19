FROM kudato/baseimage:vault

ENV CMD_USER=vault \
    VAULT_INIT_SCRIPT=/usr/bin/vault.sh

COPY vault.sh /usr/bin/
CMD [ "vault", "server", "-config=/config.hcl" ]
