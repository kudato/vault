Vault with kms auto-unseal and s3 as backend [![Build Status](https://travis-ci.org/kudato/vault.svg?branch=master)](https://travis-ci.org/kudato/vault)

Environment variables ```AWS_REGION```, ```AWS_S3_BUCKET```, ```AWS_ACCESS_KEY_ID```,```AWS_SECRET_ACCESS_KEY``` is required.

optionally:
| name                             | default          |
| -------------------------------- | ---------------- |
| ```VAULT_SERVER_MAX_LEASE_TTL``` | ```150000h```    |
| ```VAULT_SERVER_DEF_LEASE_TTL``` | ```150000h```    |
| ```VAULT_SERVER_DISABLE_MLOCK``` | ```true```       |
| ```VAULT_SERVER_PORT```          | ```8200```       |
| ```VAULT_SERVER_UI```            | ```true```       |
| ```VAULT_SERVER_TLS_DISABLE```   | ```1```          |
