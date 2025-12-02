import os
import io
import tarfile
import base64
import argparse
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

# ----------------------------
# 키 관리
# ----------------------------
def generate_key_pem(filename="aes_key.pem"):
    key = os.urandom(32)  # 256-bit
    b64_key = base64.b64encode(key).decode()
    with open(filename, "w") as f:
        f.write("-----BEGIN AES SECRET KEY-----\n")
        f.write(b64_key + "\n")
        f.write("-----END AES SECRET KEY-----\n")
    print(f"[+] Key saved to {filename}")
    return key

def load_key_pem(filename="aes_key.pem"):
    with open(filename, "r") as f:
        lines = f.read().splitlines()
        b64_key = "".join(lines[1:-1])
    return base64.b64decode(b64_key)

# ----------------------------
# 암호화 / 복호화
# ----------------------------
def encrypt_file(input_path, key):
    with open(input_path, "rb") as f:
        plaintext = f.read()
    iv = os.urandom(16)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    ciphertext = cipher.encrypt(pad(plaintext, AES.block_size))
    return iv + ciphertext

def decrypt_file(data, key):
    iv = data[:16]
    ciphertext = data[16:]
    cipher = AES.new(key, AES.MODE_CBC, iv)
    plaintext = unpad(cipher.decrypt(ciphertext), AES.block_size)
    return plaintext

# ----------------------------
# TAR 컨테이너
# ----------------------------
def add_to_container(tar_name, file_path, key):
    encrypted_data = encrypt_file(file_path, key)
    info = tarfile.TarInfo(name=os.path.basename(file_path))
    info.size = len(encrypted_data)
    with tarfile.open(tar_name, "a") as tar:
        tar.addfile(info, io.BytesIO(encrypted_data))
    print(f"[+] Added {file_path} (encrypted) to {tar_name}")

def list_container(tar_name):
    with tarfile.open(tar_name, "r") as tar:
        tar.list()

def extract_from_container(tar_name, filename, key, out_dir="."):
    with tarfile.open(tar_name, "r") as tar:
        member = tar.getmember(filename)
        f = tar.extractfile(member)
        data = f.read()
        plaintext = decrypt_file(data, key)
        out_path = os.path.join(out_dir, ("extracted_" + filename))
        with open(out_path, "wb") as out:
            out.write(plaintext)
        print(f"[+] Extracted {filename} -> {out_path}")

# ----------------------------
# 메인 실행 (간단 버전)
# ----------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Simple AES File Container")
    parser.add_argument("--genkey", action="store_true", help="Generate AES key")
    parser.add_argument("--encrypt", nargs=2, metavar=("TAR", "FILE"), help="Encrypt file and add to TAR")
    parser.add_argument("--list", metavar="TAR", help="List files in TAR")
    parser.add_argument("--extract", nargs=2, metavar=("TAR", "FILENAME"), help="Extract and decrypt file")
    args = parser.parse_args()

    # --genkey
    if args.genkey:
        generate_key_pem()
        exit()

    # 나머지 기능은 키 필요
    if not os.path.exists("aes_key.pem"):
        print("[!] AES key not found. Please generate one with --genkey")
        exit()
    key = load_key_pem()

    # --encrypt
    if args.encrypt:
        tar_name, file_path = args.encrypt
        add_to_container(tar_name, file_path, key)
        exit()

    # --list
    if args.list:
        list_container(args.list)
        exit()

    # --extract
    if args.extract:
        tar_name, filename = args.extract
        extract_from_container(tar_name, filename, key)
        exit()

    # 아무 옵션도 없을 때
    parser.print_help()

