import os
import logging
import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()

class core(pluginTemplate):
    __model__ = "core"
    __version__ = "v1"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        config = kwargs.get('config')
        if config is None:
            print("Please enter input file paths in configuration.")
            raise SystemExit(1)

        # 配置路徑
        self.dut_exe = os.path.join(config['PATH'] if 'PATH' in config else "", "core")
        self.num_jobs = str(config['jobs'] if 'jobs' in config else 1)
        self.pluginpath = os.path.abspath(config['pluginpath'])
        self.isa_spec = os.path.abspath(config['ispec'])
        self.platform_spec = os.path.abspath(config['pspec'])
        self.target_run = config.get('target_run', '1') != '0'

    def initialise(self, suite, work_dir, archtest_env):
        self.work_dir = work_dir
        self.suite_dir = suite

        # GCC 編譯指令模板
        self.compile_cmd = 'riscv{1}-unknown-elf-gcc -march={0} \
         -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g\
         -T '+self.pluginpath+'/env/link.ld\
         -I '+self.pluginpath+'/env/\
         -I ' + archtest_env + ' {2} -o {3} {4}'

    def build(self, isa_yaml, platform_yaml):
        # 從 YAML 文件中讀取 XLEN 和 ISA 信息
        ispec = utils.load_yaml(isa_yaml)['hart0']
        self.xlen = '64' if 64 in ispec['supported_xlen'] else '32'
        # self.isa = 'rv' + self.xlen + ''.join(
        #     [ext.lower() for ext in ['I', 'M', 'F', 'D', 'C'] if ext in ispec["ISA"]]
        # )
        self.isa = 'rv' + self.xlen
        if "I" in ispec["ISA"]:
            self.isa += 'i'
        if "M" in ispec["ISA"]:
            self.isa += 'm'
        #   if "F" in ispec["ISA"]:
        #       self.isa += 'f'
        #   if "D" in ispec["ISA"]:
        #       self.isa += 'd'
        #   if "C" in ispec["ISA"]:
        #       self.isa += 'c'
        self.compile_cmd += " -mabi=" + ("lp64 " if self.xlen == '64' else "ilp32 ")
    
    def runTests(self, testList):
        mfpath = os.path.join(self.work_dir, "Makefile." + self.name[:-1])
        if os.path.exists(mfpath):
            os.remove(mfpath)
        make = utils.makeUtil(makefilePath=mfpath)
        make.makeCommand = 'make -k -j' + self.num_jobs

        for testname in testList:
            testentry = testList[testname]
            test = testentry['test_path']
            test_dir = testentry['work_dir']
            elf = 'my.elf'
            sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")
            compile_macros = ' -D' + " -D".join(testentry['macros']) if testentry['macros'] else ''
            cmd = self.compile_cmd.format(
                testentry['isa'].lower() , self.xlen, test, elf, compile_macros
            )

            print(f"Compiling {testname}...")
            os.system(f"cd {test_dir} && {cmd}")

            # 檢查是否生成 ELF 檔案
            elf_path = os.path.join(test_dir, elf)
            if not os.path.exists(elf_path):
                raise FileNotFoundError(f"ELF file '{elf_path}' not found in directory {test_dir}")

            print(f"Extracting signature range from {elf}...")
            readelf_cmd = f"riscv{self.xlen}-unknown-elf-readelf -s {elf}"
            readelf_output = os.popen(f"cd {test_dir} && {readelf_cmd}").read()

            begin_signature, end_signature = None, None
            for line in readelf_output.splitlines():
                if "begin_signature" in line:
                    begin_signature = line.split()[1]
                if "end_signature" in line:
                    end_signature = line.split()[1]

            if not begin_signature or not end_signature:
                raise RuntimeError(f"Failed to extract signature range from {elf}")

            print(f"Signature range: begin=0x{begin_signature}, end=0x{end_signature}")

            objcopy_cmd = f"riscv{self.xlen}-unknown-elf-objcopy -O binary {elf} my.bin"
            
            bin2hex_cmd = "python /home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/bin_to_hex.py my.bin code.mem"

            iverilog_cmd = (
                        "iverilog -Wall -I /home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core -o simv -g2012 "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/core.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/alu.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/br_unit.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/csr.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/decoder.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/ma_ctrl.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/r_data_fmt.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/ram.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/reg_file.v "
                        + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/test_bench.v "
                    )
            vvp_cmd = (
                f"vvp simv +signature={sig_file} "
                f"+begin_signature=0x{begin_signature} +end_signature=0x{end_signature}"
            )

            simcmd = " && ".join([objcopy_cmd, bin2hex_cmd, iverilog_cmd, vvp_cmd])
            execute = f'@cd {test_dir}; {cmd}; {simcmd};'
            make.add_target(execute)

        make.execute_all(self.work_dir)

        if not self.target_run:
            raise SystemExit(0)


    # def runTests(self, testList):
    #     # 清理舊的 Makefile
    #     mfpath = os.path.join(self.work_dir, "Makefile." + self.name[:-1])
    #     if os.path.exists(mfpath):
    #         os.remove(mfpath)
    #     make = utils.makeUtil(makefilePath=mfpath)
    #     make.makeCommand = 'make -k -j' + self.num_jobs

    #     for testname in testList:
    #         testentry = testList[testname]
    #         test = testentry['test_path']
    #         test_dir = testentry['work_dir']
    #         elf = 'my.elf'
    #         sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")
    #         compile_macros = ' -D' + " -D".join(testentry['macros']) if testentry['macros'] else ''
    #         cmd = self.compile_cmd.format(
    #             testentry['isa'].lower(), self.xlen, test, elf, compile_macros
    #         )

    #         if not self.target_run:
    #             simcmd = 'echo "NO RUN"'
    #         else:
    #             readelf_cmd = f"riscv{self.xlen}-unknown-elf-readelf -s {elf}"
    #             readelf_output = os.popen(f"cd {test_dir} && {readelf_cmd}").read()

    #             begin_signature, end_signature = None, None
    #             for line in readelf_output.splitlines():
    #                 if "begin_signature" in line:
    #                     begin_signature = line.split()[1]
    #                 if "end_signature" in line:
    #                     end_signature = line.split()[1]

    #             if not begin_signature or not end_signature:
    #                 raise RuntimeError(f"Failed to extract signature range from {elf}")

    #             print(f"Signature range: begin=0x{begin_signature}, end=0x{end_signature}")

    #             # ELF -> MEM
    #             # elf2hex_cmd = (
    #             #     f"elf2hex 4 1048576 my.elf 0x80000000 > code.mem" # jal有40幾萬行==
    #             #     # f"elf2hex 4 16777216 my.elf 0x80000000 > code.mem"
    #             # )

    #             # ELF2BIN
    #             objcopy_cmd = f"riscv{self.xlen}-unknown-elf-objcopy -O binary {elf} my.bin"

    #             # Step 2: Binary -> HEX
    #             bin2hex_cmd = "python /home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/bin_to_hex.py my.bin code.mem"

    #             # 編譯 Verilog
    #             iverilog_cmd = (
    #                 "iverilog -Wall -I /home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core -o simv -g2012 "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/core.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/alu.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/br_unit.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/csr.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/decoder.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/ma_ctrl.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/r_data_fmt.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/ram.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/reg_file.v "
    #                 + "/home/eason/Desktop/ComputerArchitecture/Final_Project/rv32_core/core/test_bench.v "
    #             )

    #             # 模擬執行
    #             # vvp_cmd = f"vvp simv +signature={sig_file}"
    #             vvp_cmd = (
    #             f"vvp simv +signature={sig_file} "
    #             f"+begin_signature=0x{begin_signature} +end_signature=0x{end_signature}"
    #             )

    #             # 合併指令
    #             # simcmd = elf2hex_cmd + " && " + iverilog_cmd + " && " + vvp_cmd
    #             simcmd = " && ".join([objcopy_cmd, bin2hex_cmd, iverilog_cmd, vvp_cmd])

    #         execute = '@cd {0}; {1}; {2};'.format(test_dir, cmd, simcmd)
    #         make.add_target(execute)

    #     make.execute_all(self.work_dir)

    #     if not self.target_run:
    #         raise SystemExit(0)

