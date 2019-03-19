echo "start the vault"
# vault server -config=/config/config.json &

echo "start using vault"
sleep 10
# Or Host name
export VAULT_API_ADDR="http://127.0.0.1:8200"
export VAULT_ADDR="http://127.0.0.1:8200"

echo "start the vault and save key to keys.txt file"
vault operator init -address=${VAULT_ADDR} > keys.txt

echo "unseal the vault"
vault unseal -address=${VAULT_ADDR} $(grep 'Key 1:' keys.txt | awk '{print $NF}')
vault unseal -address=${VAULT_ADDR} $(grep 'Key 2:' keys.txt | awk '{print $NF}')
vault unseal -address=${VAULT_ADDR} $(grep 'Key 3:' keys.txt | awk '{print $NF}')

echo "export the vault token"
export VAULT_TOKEN=$(grep 'Initial Root Token:' keys.txt | awk '{print substr($NF, 1, length($NF)-1)}')

echo "check the status"
vault status -address=${VAULT_ADDR}

echo "auth the vault using token"
vault auth -address=${VAULT_ADDR} ${VAULT_TOKEN}
