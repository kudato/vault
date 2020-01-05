#!/usr/bin/env bash
source /usr/bin/lib.sh

for i in \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_S3_REGION=us-east-1 \
    AWS_S3_PATH,AWS_S3_BUCKET_PATH="" \
    AWS_S3_BUCKET,AWS_S3_BUCKET_NAME="" \
    AWS_ACCESS_KEY_ID,AWS_S3_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY,AWS_S3_SECRET_ACCESS_KEY="" \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_KMS_REGION=us-east-1 \
    AWS_KMS_KEY_ID=false \
    VAULT_SERVER_MAX_LEASE_TTL=1h \
    VAULT_SERVER_DEF_LEASE_TTL=1h \
    VAULT_SERVER_DISABLE_MLOCK=false \
    VAULT_SERVER_LOG_FORMAT=json \
    VAULT_SERVER_ADDR=0.0.0.0 \
    VAULT_SERVER_PORT=8200 \
    VAULT_SERVER_TLS_DISABLE=1 \
    VAULT_SERVER_TLS_KEY=false \
    VAULT_SERVER_TLS_CERT=false \
    VAULT_SERVER_UI=true \
    VAULT_SERVET_X_FWD_ALLOW_ADDR=false
do
    defaultEnv "${i}"
done

cat <<EOF > /config.hcl
storage "s3" {
  access_key = "${AWS_S3_ACCESS_KEY_ID}"
  secret_key = "${AWS_S3_SECRET_ACCESS_KEY}"

  region	 = "${AWS_S3_REGION}"
  bucket   = "${AWS_S3_BUCKET_NAME}"
  path     = "${AWS_S3_BUCKET_PATH}"
}

listener "tcp" {
  address     = "${VAULT_SERVER_ADDR}:${VAULT_SERVER_PORT}"
  tls_disable = ${VAULT_SERVER_TLS_DISABLE}
#TLS#  tls_cert_file = "${VAULT_SERVER_TLS_CERT}"
#TLS#  tls_key_file  = "${VAULT_SERVER_TLS_KEY}"
#XFWD#  x_forwarded_for_authorized_addrs = "${VAULT_SERVET_X_FWD_ALLOW_ADDR}"
}

#KMS#seal "awskms" {
#KMS#  region     = "${AWS_KMS_REGION}"
#KMS#  kms_key_id = "${AWS_KMS_KEY_ID}"
#KMS#}

ui = ${VAULT_SERVER_UI}
max_lease_ttl = "${VAULT_SERVER_MAX_LEASE_TTL}"
default_lease_ttl = "${VAULT_SERVER_DEF_LEASE_TTL}"
disable_mlock = ${VAULT_SERVER_DISABLE_MLOCK}
log_format = "${VAULT_SERVER_LOG_FORMAT}"
EOF

if [[ "${VAULT_SERVER_DISABLE_MLOCK}" == "false" ]]
then
    setcap cap_ipc_lock=+ep "$(readlink -f "$(which vault)")"
fi

if [[ "${VAULT_SERVER_TLS_DISABLE}" != "1" ]]
then
    sed -i "s|#TLS#||g" /config.hcl
fi

if [[ "${VAULT_SERVET_X_FWD_ALLOW_ADDR}" != "false" ]]
then
    sed -i "s|#XFWD#||g" /config.hcl
fi

if [[ "${AWS_KMS_KEY_ID}" != "false" ]]
then
    sed -i "s|#KMS#||g" /config.hcl
fi
