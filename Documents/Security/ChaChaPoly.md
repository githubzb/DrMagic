ChaChaPoly

[chacha poly1305](https://en.wikipedia.org/wiki/ChaCha20-Poly1305)加密算法

1、带校验码的加密

```swift
public static func encrypt(message: String, keyHex: String, nonceHex: String?, authenticating: String) throws -> DrChaChaPoly.SealedBox
```

参数说明：

- message：待加密的明文字符串（会经过UTF8编码）
- keyHex：秘钥key（16进制字符串，64字节长度）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

```swift
public static func encrypt(message: Data, keyHex: String, nonceHex: String?, authenticating: String) throws -> DrChaChaPoly.SealedBox
```

参数说明：

- message：待加密的明文数据
- keyHex：秘钥key（16进制字符串，64字节长度）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

2、不带校验码的加密

```swift
public static func encrypt(message: String, keyHex: String, nonceHex: String?) throws -> DrChaChaPoly.SealedBox
```

参数说明：

- message：待加密的明文字符串（会经过UTF8编码）
- keyHex：秘钥key（16进制字符串，64字节长度）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）

```swift
public static func encrypt(message: Data, keyHex: String, nonceHex: String?) throws -> DrChaChaPoly.SealedBox
```

参数说明：

- message：待加密的明文数据
- keyHex：秘钥key（16进制字符串，64字节长度）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）

3、带校验码的解密

```swift
public static func decrypt(sealedBox: DrChaChaPoly.SealedBox, keyHex: String, authenticating: String) throws -> String
```

参数说明：

- sealedBox：待解密的包装数据
- keyHex：秘钥key（16进制字符串，64字节长度）
- authenticating：校验字符串

```swift
public static func decryptData(sealedBox: DrChaChaPoly.SealedBox, keyHex: String, authenticating: String) throws -> Data
```

参数说明：

- sealedBox：待解密的包装数据
- keyHex：秘钥key（16进制字符串，64字节长度）
- authenticating：校验字符串

4、不带校验码的解密

```swift
public static func decrypt(sealedBox: DrChaChaPoly.SealedBox, keyHex: String) throws -> String
```

参数说明：

- sealedBox：待解密的包装数据
- keyHex：秘钥key（16进制字符串，64字节长度）

```swift
public static func decryptData(sealedBox: DrChaChaPoly.SealedBox, keyHex: String) throws -> Data
```

参数说明：

- sealedBox：待解密的包装数据
- keyHex：秘钥key（16进制字符串，64字节长度）

5、生成加密所需的秘钥key

```swift
public static var generateKeyData: Data
public static var generateKeyHex: String  // 16进制字符串
```

6、生成加密所需的随机串（16进制字符串）

```swift
public static var nonceHex: String
```

7、加密结果包装类**SealedBox**

```swift
struct SealedBox {
	var tag: Data { get }
	// 加密的密文
	var ciphertext: Data { get }
	var nonce: Data { get }
	// ( nonce + ciphertext + tag)
	var combined: Data { get }
}
```