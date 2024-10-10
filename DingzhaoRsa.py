import hashlib
import time
import os
from cryptography.hazmat.backends import default_backend # type: ignore
from cryptography.hazmat.primitives.asymmetric import rsa, padding # type: ignore
from cryptography.hazmat.primitives import hashes # type: ignore

# 生成 RSA 公私钥对
def generate_key_pair():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    public_key = private_key.public_key()
    return private_key, public_key

# 使用私钥对数据进行签名
def sign_data(private_key, data):
    signature = private_key.sign(
        data,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()
    )
    return signature

# 使用公钥验证签名
def verify_signature(public_key, data, signature):
    try:
        public_key.verify(
            signature,
            data,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        return True
    except Exception:
        return False

# 寻找 nonce 以满足哈希条件
def find_nonce(nickname, prefix_zeros):
    nonce = 0
    target = '0' * prefix_zeros
    while True:
        input_string = f"{nickname}{nonce}".encode()
        hash_result = hashlib.sha256(input_string).hexdigest()
        if hash_result.startswith(target):
            return nonce, hash_result

# 主程序
def main():
    # 生成公私钥对
    private_key, public_key = generate_key_pair()
    nickname = "dingzhao"

    # 寻找 nonce 以满足 4 个 0 开头的哈希值
    nonce, hash_result = find_nonce(nickname, 4)
    print(f"找到 nonce: {nonce}, 哈希值: {hash_result}")

    # 使用私钥签名
    signature = sign_data(private_key, f"{nickname}{nonce}".encode())
    print(f"签名: {signature.hex()}")

    # 验证签名
    is_valid = verify_signature(public_key, f"{nickname}{nonce}".encode(), signature)
    print(f"签名验证结果: {'有效' if is_valid else '无效'}")

if __name__ == "__main__":
    main()
