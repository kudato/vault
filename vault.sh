#!/usr/bin/env bash
source /usr/bin/lib.sh

for i in \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_S3_REGION=us-east-1 \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_KMS_REGION=us-east-1 \
    AWS_KMS_KEY_ID=none \
    VAULT_SERVER_MAX_LEASE_TTL=1h \
    VAULT_SERVER_DEF_LEASE_TTL=1h \
    VAULT_SERVER_DISABLE_MLOCK=true \
    VAULT_SERVER_TLS_DISABLE=1 \
    VAULT_SERVER_PORT=8200 \
    VAULT_SERVER_UI=true
do
    defaultEnv "${i}"
done

cat <<EOF > /config.hcl
storage "s3" {
  region	 = "${AWS_S3_REGION}"
}

listener "tcp" {
 address     = "0.0.0.0:${VAULT_SERVER_PORT}"
 tls_disable = ${VAULT_SERVER_TLS_DISABLE}
}

seal "awskms" {
  region     = "${AWS_KMS_REGION}"
  kms_key_id = "${AWS_KMS_KEY_ID}"
}

ui = ${VAULT_SERVER_UI}
max_lease_ttl = "${VAULT_SERVER_MAX_LEASE_TTL}"
default_lease_ttl = "${VAULT_SERVER_DEF_LEASE_TTL}"
disable_mlock = ${VAULT_SERVER_DISABLE_MLOCK}
EOF
