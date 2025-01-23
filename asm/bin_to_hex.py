# bin_to_hex.py
import sys

def bin_to_hex(bin_file, mem_file, width=4):
    with open(bin_file, 'rb') as f_in, open(mem_file, 'w') as f_out:
        while True:
            bytes_read = f_in.read(width)
            if not bytes_read:
                break
            # 如果讀取的位元組數少於 width，則填充 0
            bytes_read = bytes_read.ljust(width, b'\x00')
            # Little-endian 轉換
            word = int.from_bytes(bytes_read, byteorder='little')
            f_out.write("{:08x}\n".format(word))

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python bin_to_hex.py <input.bin> <output.mem>")
        sys.exit(1)
    bin_to_hex(sys.argv[1], sys.argv[2])

