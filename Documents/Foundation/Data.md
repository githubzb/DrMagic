## Data

1、MD5（返回16进制字符串）

```swift
public var md5String: String
public var md5: MagicBox<Data> // 结果为md5String的UTF8编码Data
```

2、SHA1（返回16进制字符串）

```swift
public var sha1String: String
public var sha1: MagicBox<Data> // 结果为sha1String的UTF8编码Data
```

3、SHA256（返回16进制字符串）

```swift
public var sha256String: String
public var sha256: MagicBox<Data> // 结果为sha256String的UTF8编码Data
```

4、SHA384（返回16进制字符串）

```swift
public var sha384String: String
public var sha384: MagicBox<Data> // 结果为sha384String的UTF8编码Data
```

5、SHA512（返回16进制字符串）

```swift
public var sha512String: String
public var sha512: MagicBox<Data> // 结果为sha512String的UTF8编码Data
```

6、HMAC（返回16进制字符串）

```swift
public func hmac(type: HMACType, key: String) -> String?
```

7、转UTF8字符串

```swift
public var utf8String: String
```

8、转指定编码的字符串（默认：UTF8）

```swift
public func toString(encoding: String.Encoding = .utf8) -> String
```

9、转16进制字符串（小写）

```swift
public var hexString: String
```

10、转16进制字符串（大写）

```swift
public var hexStringUpperCase: String
```