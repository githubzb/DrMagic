## AES

AES in GCM mode with 128-bit tags加密算法

1、带校验码的加密

```swift
public static func encrypt(message: String, keyHex: String, nonceHex: String?, authenticating: String) throws -> GCM.SealedBox
```

参数说明：

- message：待加密的明文字符串（会经过UTF8编码）
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

```swift
public static func encrypt(message: Data, keyHex: String, nonceHex: String?, authenticating: String) throws -> GCM.SealedBox
```

参数说明：

- message：待加密的明文数据
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

2、不带校验码的加密

```swift
public static func encrypt(message: String, keyHex: String, nonceHex: String?) throws -> GCM.SealedBox
```

参数说明：

- message：待加密的明文字符串（会经过UTF8编码）
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）

```swift
public static func encrypt(message: Data, keyHex: String, nonceHex: String?) throws -> GCM.SealedBox
```

参数说明：

- message：待加密的明文数据
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- nonceHex：随机串，参与加密（16进制字符串，24字节长度）

3、带校验码的解密

```swift
public static func decrypt(sealedBox: GCM.SealedBox, keyHex: String, authenticating: String) throws -> String
```

参数说明：

- sealedBox：待解密的包装类
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

```swift
public static func decryptData(sealedBox: GCM.SealedBox, keyHex: String, authenticating: String) throws -> Data
```

参数说明：

- sealedBox：待解密的包装类
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）
- authenticating：校验字符串，只做校验，不参与加密（可以理解为签名，会经过UTF8编码）

4、不带校验码的解密

```swift
public static func decrypt(sealedBox: GCM.SealedBox, keyHex: String) throws -> String
```

参数说明：

- sealedBox：待解密的包装类
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）

```swift
public static func decryptData(sealedBox: GCM.SealedBox, keyHex: String) throws -> Data
```

参数说明：

- sealedBox：待解密的包装类
- keyHex：秘钥key（16进制字符串，16字节、24字节、32字节）

5、生成AES加密的秘钥

```swift
public static var generate128KeyData: Data // 16字节秘钥
public static var generate192KeyData: Data // 24字节秘钥
public static var generate256KeyData: Data // 32字节秘钥

public static var generate128KeyHex: String // 16字节秘钥（16进制字符串）
public static var generate192KeyHex: String // 24字节秘钥（16进制字符串）
public static var generate256KeyHex: String // 32字节秘钥（16进制字符串）
```

6、生成AES加密的随机串（16进制字符串）

```swift
public static var nonceHex: String
```

7、根据IETF RFC 3394规范，封装AES加密秘钥（对秘钥加密）

```swift
public static func wrap(_ keyToWrap: Data, byKey: Data) throws -> Data 
```

参数说明：

- keyToWrap：待封装的秘钥数据
- byKey：用于封装秘钥的秘钥数据

```swift
public static func wrap(_ keyToWrapHex: String, byKeyHex: String) throws -> String 
```

参数说明：

- keyToWrapHex：待封装的秘钥（16进制字符串）
- byKeyHex：用于封装秘钥的秘钥（16进制字符串）

8、根据IETF RFC 3394规范，解封装AES加密秘钥（对秘钥解密）

```swift
public static func unwrap(_ wrappedKey: Data, byKey: Data) throws -> Data
```

参数说明：

- wrappedKey：待解封的秘钥
- byKey：用于解封秘钥的秘钥（需要与封装时的秘钥对称）

```swift
public static func unwrap(_ wrappedKeyHex: String, byKeyHex: String) throws -> String
```

参数说明：

- wrappedKeyHex：待解封的秘钥（16进制字符串）
- byKeyHex：用于解封秘钥的秘钥（需要与封装时的秘钥对称，16进制字符串）

9、加密结果封装类 **SealedBox**

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

