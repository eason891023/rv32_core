#!/bin/bash

ELF_FILE=$1
if [ -z "$ELF_FILE" ]; then
    echo "Usage: $0 <elf-file>"
    exit 1
fi

BEGIN_SIGNATURE=$(riscv32-unknown-elf-readelf -s "$ELF_FILE" | grep begin_signature | awk '{print $2}')
END_SIGNATURE=$(riscv32-unknown-elf-readelf -s "$ELF_FILE" | grep end_signature | awk '{print $2}')

echo "begin_signature: 0x$BEGIN_SIGNATURE"
echo "end_signature: 0x$END_SIGNATURE"

