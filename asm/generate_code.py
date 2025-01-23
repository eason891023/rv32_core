import os
import subprocess
import sys

def run_command(command, cwd=None):
    try:
        print(f"run command: {command}")
        result = subprocess.run(command, shell=True, cwd=cwd, check=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Fail: {command}")
        print(e.stderr)
        sys.exit(1)

def compile_to_elf(source_file, output_elf, linker_script, include_dirs = None):
    # include_flags = " ".join([f"-I {include}" for include in include_dirs])
    compile_cmd = f"riscv32-unknown-elf-gcc -march=rv32i -static -mcmodel=medany -fvisibility=hidden " \
                  f"-nostdlib -nostartfiles -g -T {linker_script} -o {output_elf} {source_file}"
    run_command(compile_cmd)

def elf_to_bin(elf_file, bin_file):
    objcopy_cmd = f"riscv32-unknown-elf-objcopy -O binary {elf_file} {bin_file}"
    run_command(objcopy_cmd)

def bin_to_hex(bin_file, hex_file, script_path):
    bin2hex_cmd = f"python {script_path} {bin_file} {hex_file}"
    run_command(bin2hex_cmd)

def load_to_hardware(hex_file, Verilog_main, verilog_testbench, simulation_directory, iverilog_path="iverilog", vvp_path="vvp"):
    compile_cmd = f"{iverilog_path} -Wall -I /home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main -o simv -g2012 {Verilog_main} {verilog_testbench}"
    run_command(compile_cmd, cwd=simulation_directory)
    # run simulate
    simulation_cmd = f"{vvp_path} simv"
    run_command(simulation_cmd, cwd=simulation_directory)

def main():
    # path
    source_file = "shift_and_add_mul.S"     # target assembly code
    output_elf = f"{source_file}.elf"       # .elf file
    output_bin = f"{source_file}.bin"       # binary file
    output_hex = f"{source_file}.mem"       # HEX file
    linker_script = "./env/link.ld"         # Linker script
    bin_to_hex_script = "./bin_to_hex.py"  # bin_to_hex.py 
    verilog_testbench = "../core/src/test/test_bench.v"      # Verilog test_bench
    Verilog_main = (
                        "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/core.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/alu.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/br_unit.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/csr.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/decoder.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/ma_ctrl.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/r_data_fmt.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/ram.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/src/main/reg_file.v ")

    simulation_directory = "./"
    if not os.path.exists(source_file):
        print(f"File Not Found: {source_file}")
        sys.exit(1)

    if not os.path.exists(linker_script):
        print(f"Linker Script Not Found: {linker_script}")
        sys.exit(1)

    # compile .S 2 .elf
    # compile_to_elf(source_file, output_elf, linker_script, include_dirs)
    compile_to_elf(source_file, output_elf, linker_script)

    # transfer .elf 2 binary
    elf_to_bin(output_elf, output_bin)

    # transfer binary 2 hex
    bin_to_hex(output_bin, output_hex, bin_to_hex_script)

    print(f"Generate Success: {output_hex}")
    print(f"Start Simulation...")
    load_to_hardware(output_hex, Verilog_main, verilog_testbench, simulation_directory)
    print("simulation done")

if __name__ == "__main__":
    main()