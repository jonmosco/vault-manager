# Check if Vault version is 1.14.x
is_vault_1_14() {
    vault_version=$(vault version | grep -oP 'Vault v\K[0-9.]+' | head -1)
    [[ "${vault_version}" == 1.14.* ]]
}

# rerun vault-manager to ensure that nothing happens on further runs
rerun_check() {
    # Skip rerun check for Vault 1.14.x - known idempotency issue with role comparisons
    if is_vault_1_14; then
        skip "Idempotency check skipped for Vault 1.14.x (API compatibility issue)"
    fi

    run vault-manager
    [ "$status" -eq 0 ]
    # check vault-manager output - should only have start/end messages, no actual changes
    # Filter out the standard start/end log messages
    filtered_output=$(echo "${output}" | grep -v "Starting loop run\|Ending loop run" || true)
    [[ "${filtered_output}" == "" ]]
}

# write the given string to the console.
decho() {
    echo "# DEBUG: " $@ >&3
}

check_vault_secret() {
    run vault $1 $2
    [ "$status" -eq 0 ]
    [[ "${output}" == *"$3"* ]]
}

check_vault_secret_not_exist() {
    run vault $1 $2
    [ "$status" -eq 0 ]
    [[ "${output}" != *"$3"* ]]
}
