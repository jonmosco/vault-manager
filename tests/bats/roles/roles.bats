#!/usr/bin/env bats

load ../helpers

@test "test vault-manager manage roles" {
    #
    # CASE: create roles
    #
    export GRAPHQL_QUERY_FILE=/tests/fixtures/roles/enable_vault_roles.graphql
    run vault-manager
    [ "$status" -eq 0 ]
    # check vault-manager output
    [[ "${output}" == *"[Vault Role] role is successfully written"*"instance=\"${PRIMARY_VAULT_URL}\""*"path=auth/approle/role/app-interface"*"type=approle"* ]]
    [[ "${output}" == *"[Vault Role] role is successfully written"*"instance=\"${PRIMARY_VAULT_URL}\""*"path=auth/approle/role/vault_manager"*"type=approle"* ]]
    [[ "${output}" == *"[Vault Role] role is successfully written"*"instance=\"${SECONDARY_VAULT_URL}\""*"path=auth/approle/role/app-interface"*"type=approle"* ]]
    [[ "${output}" == *"[Vault Role] role is successfully written"*"instance=\"${SECONDARY_VAULT_URL}\""*"path=auth/approle/role/vault_manager"*"type=approle"* ]]

    # check approles created
    run vault list -address="${PRIMARY_VAULT_URL}" auth/approle/role
    [ "$status" -eq 0 ]
    [[ "${output}" == *"app-interface"* ]]
    [[ "${output}" == *"vault_manager"* ]]

    # check approle config
    run vault read -address="${PRIMARY_VAULT_URL}" auth/approle/role/app-interface
    [ "$status" -eq 0 ]
    [[ "${output}" == *"token_num_uses"*"0"* ]]
    [[ "${output}" == *"token_ttl"*"30m"* ]]
    [[ "${output}" == *"token_max_ttl"*"30m"* ]]
    [[ "${output}" == *"policies"*"[app-interface-approle-policy app-sre-policy]"* ]]
    [[ "${output}" == *"period"*"0s"* ]]
    [[ "${output}" == *"secret_id_ttl"*"0s"* ]]
    [[ "${output}" == *"secret_id_num_uses"*"0"* ]]
    [[ "${output}" == *"bind_secret_id"*"true"* ]]
    [[ "${output}" == *"local_secret_ids"*"false"* ]]
    [[ "${output}" == *"token_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"secret_id_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"token_type"*"default"* ]]
    # check approle config
    run vault read -address="${PRIMARY_VAULT_URL}" auth/approle/role/vault_manager
    [ "$status" -eq 0 ]
    [[ "${output}" == *"token_num_uses"*"0"* ]]
    [[ "${output}" == *"token_ttl"*"30m"* ]]
    [[ "${output}" == *"token_max_ttl"*"30m"* ]]
    [[ "${output}" == *"policies"*"[vault-oidc-app-sre-policy]"* ]]
    [[ "${output}" == *"period"*"0s"* ]]
    [[ "${output}" == *"secret_id_ttl"*"0s"* ]]
    [[ "${output}" == *"secret_id_num_uses"*"0"* ]]
    [[ "${output}" == *"bind_secret_id"*"true"* ]]
    [[ "${output}" == *"local_secret_ids"*"false"* ]]
    [[ "${output}" == *"token_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"secret_id_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"token_type"*"default"* ]]

    # run same tests against secondary instance
    export VAULT_ADDR=${SECONDARY_VAULT_URL}

    # check approles created
    run vault list auth/approle/role
    [ "$status" -eq 0 ]
    [[ "${output}" == *"app-interface"* ]]
    [[ "${output}" == *"vault_manager"* ]]

    # check approle config
    run vault read auth/approle/role/app-interface
    [ "$status" -eq 0 ]
    [[ "${output}" == *"token_num_uses"*"0"* ]]
    [[ "${output}" == *"token_ttl"*"30m"* ]]
    [[ "${output}" == *"token_max_ttl"*"30m"* ]]
    [[ "${output}" == *"policies"*"[app-interface-approle-policy]"* ]]
    [[ "${output}" == *"period"*"0s"* ]]
    [[ "${output}" == *"secret_id_ttl"*"0s"* ]]
    [[ "${output}" == *"secret_id_num_uses"*"0"* ]]
    [[ "${output}" == *"bind_secret_id"*"true"* ]]
    [[ "${output}" == *"local_secret_ids"*"false"* ]]
    [[ "${output}" == *"token_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"secret_id_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"token_type"*"default"* ]]
    # check approle config
    run vault read auth/approle/role/vault_manager
    [ "$status" -eq 0 ]
    [[ "${output}" == *"token_num_uses"*"0"* ]]
    [[ "${output}" == *"token_ttl"*"30m"* ]]
    [[ "${output}" == *"token_max_ttl"*"30m"* ]]
    [[ "${output}" == *"policies"*"[vault-oidc-app-sre-policy]"* ]]
    [[ "${output}" == *"period"*"0s"* ]]
    [[ "${output}" == *"secret_id_ttl"*"0s"* ]]
    [[ "${output}" == *"secret_id_num_uses"*"0"* ]]
    [[ "${output}" == *"bind_secret_id"*"true"* ]]
    [[ "${output}" == *"local_secret_ids"*"false"* ]]
    [[ "${output}" == *"token_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"secret_id_bound_cidrs"*"[]"* ]]
    [[ "${output}" == *"token_type"*"default"* ]]

    export VAULT_ADDR=${PRIMARY_VAULT_URL}
    rerun_check
}
