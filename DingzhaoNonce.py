import hashlib
import time

def find_nonce(ding_zhao, prefix_zeros):
    nonce = 0
    target = '0' * prefix_zeros
    start_time = time.time()

    while True:
        # 创建待哈希字符串
        input_string = f"{ding_zhao}{nonce}"
        # 计算 SHA-256 哈希值
        hash_result = hashlib.sha256(input_string.encode()).hexdigest()

        # 检查哈希值是否满足条件
        if hash_result.startswith(target):
            elapsed_time = time.time() - start_time
            print(f"找到 nonce: {nonce}")
            print(f"哈希内容: {input_string}")
            print(f"哈希值: {hash_result}")
            print(f"花费时间: {elapsed_time:.2f} 秒")
            break

        nonce += 1

# 首先寻找以4个0开头的哈希值
find_nonce("丁钊", 4)

# 再寻找以5个0开头的哈希值
find_nonce("丁钊", 5)
