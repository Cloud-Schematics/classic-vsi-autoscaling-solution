OUTPUT=$(echo $IC_ENV_TAGS)
jq -n --arg env_var $OUTPUT \
        '{
          "env_var":$env_var,
        }'