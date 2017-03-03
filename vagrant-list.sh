#!/usr/bin/env bash

temp_file=/tmp/.vagrant-list.tmp

clear && vagrant global-status --prune > "${temp_file}"

num_lines=$(wc -l < "${temp_file}")

[[ "${num_lines}" -eq 5 ]] && echo -e "\n\e[91mSorry! No vagrant machines running!\n" && exit 1

directories=$(head -$(("${num_lines}" - 7)) "${temp_file}" | tail +3 | awk '{ print $NF }')

while read directory; do
    (
        echo -e "\n*** Ports for \e[32m${directory}\e[0m ***\n" && cd "${directory}" && vagrant port | tail +5
    )
done <<< "${directories}"

echo -e "\n"
rm -f "${temp_file}"
