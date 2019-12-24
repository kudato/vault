#!/usr/bin/env bash
source /usr/bin/lib.sh

for i in \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_S3_REGION=us-east-1 \
    AWS_S3_PATH,AWS_S3_BUCKET_PATH="" \
    AWS_S3_BUCKET,AWS_S3_BUCKET_NAME="" \
    AWS_ACCESS_KEY_ID,AWS_S3_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY,AWS_S3_SECRET_ACCESS_KEY="" \
    AWS_REGION,AWS_DEFAULT_REGION,AWS_KMS_REGION=us-east-1 \
    AWS_KMS_KEY_ID=False \
    VAULT_SERVER_MAX_LEASE_TTL=1h \
    VAULT_SERVER_DEF_LEASE_TTL=1h \
    VAULT_SERVER_DISABLE_MLOCK=false \
    VAULT_SERVER_LOG_FORMAT=json \
    VAULT_SERVER_TLS_DISABLE=1 \
    VAULT_SERVER_PORT=8200 \
    VAULT_SERVER_UI=true
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
 address     = "0.0.0.0:${VAULT_SERVER_PORT}"
 tls_disable = ${VAULT_SERVER_TLS_DISABLE}
}

##seal "awskms" {
##  region     = "${AWS_KMS_REGION}"
##  kms_key_id = "${AWS_KMS_KEY_ID}"
##}

ui = ${VAULT_SERVER_UI}
max_lease_ttl = "${VAULT_SERVER_MAX_LEASE_TTL}"
default_lease_ttl = "${VAULT_SERVER_DEF_LEASE_TTL}"
disable_mlock = ${VAULT_SERVER_DISABLE_MLOCK}
log_format = "${VAULT_SERVER_LOG_FORMAT}"
EOF

if [[ "${VAULT_SERVER_DISABLE_MLOCK}" == "false" ]]
then
    setcap cap_ipc_lock=+ep $(readlink -f $(which vault))
fi

if [[ "${AWS_KMS_KEY_ID}" != "False" ]]
then
    sed -i "s|##||g" /config.hcl
fi
