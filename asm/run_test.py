import os
import subprocess
import sys

def run_command(command, cwd=None):
    """執行 Shell 指令，並檢查是否執行成功。"""
    try:
        print(f"執行指令: {command}")
        result = subprocess.run(command, shell=True, cwd=cwd, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"指令失敗: {command}")
        print(e.stderr)
        sys.exit(1)

def compile_to_elf(source_file, output_elf, linker_script, include_dirs = None):
    """將 .S 檔案編譯為 ELF 格式檔案。"""
    # include_flags = " ".join([f"-I {include}" for include in include_dirs])
    compile_cmd = f"riscv32-unknown-elf-gcc -march=rv32i -static -mcmodel=medany -fvisibility=hidden " \
                  f"-nostdlib -nostartfiles -g -T {linker_script} -o {output_elf} {source_file}"
    run_command(compile_cmd)

def elf_to_bin(elf_file, bin_file):
    """將 ELF 檔案轉換為二進制格式。"""
    objcopy_cmd = f"riscv32-unknown-elf-objcopy -O binary {elf_file} {bin_file}"
    run_command(objcopy_cmd)

def bin_to_hex(bin_file, hex_file, script_path):
    """使用 bin_to_hex.py 將二進制檔案轉換為 HEX 格式。"""
    bin2hex_cmd = f"python {script_path} {bin_file} {hex_file}"
    run_command(bin2hex_cmd)

def main():
    # 設定檔案路徑
    source_file = "shift_and_add_mul.S"  # 輸入的 .S 檔案
    output_elf = "my.elf"               # 中間 ELF 檔案
    output_bin = "my.bin"               # 中間 Binary 檔案
    output_hex = "code.mem"             # 最終生成的 HEX 檔案
    linker_script = "./env/link.ld"  # Linker script 路徑
    # include_dirs = ["/path/to/env"]     # Include 目錄路徑
    bin_to_hex_script = "./bin_to_hex.py"  # bin_to_hex.py 腳本路徑

    # 確認檔案是否存在
    if not os.path.exists(source_file):
        print(f"找不到檔案: {source_file}")
        sys.exit(1)

    if not os.path.exists(linker_script):
        print(f"找不到 Linker Script: {linker_script}")
        sys.exit(1)

    if not os.path.exists(bin_to_hex_script):
        print(f"找不到 bin_to_hex.py: {bin_to_hex_script}")
        sys.exit(1)

    # 步驟 1: 編譯 .S 檔案為 ELF
    # compile_to_elf(source_file, output_elf, linker_script, include_dirs)
    compile_to_elf(source_file, output_elf, linker_script)

    # 步驟 2: 將 ELF 檔案轉為 Binary
    elf_to_bin(output_elf, output_bin)

    # 步驟 3: 將 Binary 檔案轉為 HEX
    bin_to_hex(output_bin, output_hex, bin_to_hex_script)

    print(f"成功生成 HEX 檔案: {output_hex}")

if __name__ == "__main__":
    main()