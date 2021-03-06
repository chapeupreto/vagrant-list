#!/usr/bin/env bash

which -s vagrant
if [[ $? -ne 0 ]]; then
    echo -e "\n\e[91mSorry! vagrant was not found!\e[0m\n"
    exit 1
fi

temp_file=/tmp/.vagrant-list.tmp

clear && vagrant global-status --prune > "${temp_file}" 2> /dev/null

num_lines=$(wc -l < "${temp_file}")

[[ "${num_lines}" -eq 5 ]] && echo -e "\n\e[91mSorry! No vagrant machines running!\e[0m\n" && rm -f "${temp_file}" && exit 1

directories=$(head -$(("${num_lines}" - 7)) "${temp_file}" | tail +3 | awk '{ print $NF }')

while read directory; do
    (
        echo -e "\n*** Ports for \e[32m${directory}\e[0m ***\n" && cd "${directory}" && vagrant port | tail +5
    )
done <<< "${directories}"

echo -e "\n"
rm -f "${temp_file}"
