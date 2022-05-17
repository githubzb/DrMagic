## String

对String操作返回修改后的String的包装类，你可以采用链式调用，若要取出修改后的String，调用包装类的value属性。例如：对String进行urlEncoding，然后在进行md5，返回结果字符串：

```swift
let str = "这里是加密前的内容"
let resStr = str.mg.urlEncoding.md5.value
```

1、对字符串进行base64编码

```swift
public var base64Encoding: MagicBox<String>
public func base64Encoding(options: Data.Base64EncodingOptions = []) -> MagicBox<String>
```

2、对base64字符串进行解码

```swift
public var base64Decoding: MagicBox<String>
public func base64Decoding(options: Data.Base64DecodingOptions = []) -> MagicBox<String>
```

3、对字符串进行URLEncoding编码，在**CharacterSet.urlQueryAllowed**基础上去除以下字符：:#[]@!$&'()*+,;=增加空格字符。

```swift
public var urlEncoding: MagicBox<String>
```

4、对url的query部分进行URLEncoding编码。例如："https://www.baidu.com/search?keyword="URL编码""，仅仅会对"?"后面的参数部分进行URLEncoding编码。而如果调用上面的方法进行编码结果则是如下："**https%3A//www.baidu.com/search?keyword%3DURL%E7%BC%96%E7%A0%81**"，明显":"也被编码成了%3A。

```swift
public var urlQueryEncoding: MagicBox<String>
```

5、对字符串进行编码，指定不编码的字符。在字符串中被指定的字符将不被编码，例如：对字符串"abcd#ddff?dd"进行编码，指定不编码的字符为"\#bcdf"，那么编码后的字符串为："%61bcd#ddff%3Fdd"，只有字符"a"和"?"被编码了。

```swift
public func percentEncoding(withAllowedCharacters charset: CharacterSet) -> MagicBox<String>
```

6、对字符串进行URLDecode解码，解码失败返回原字符串

```swift
public var urlDecoding: MagicBox<String>
```

7、字符串MD5（返回16进制字符串）

```swift
public var md5: MagicBox<String>
```

8、字符串SHA1（返回16进制字符串）

```swift
public var sha1: MagicBox<String>
```

9、字符串SHA256（返回16进制字符串）

```swift
public var sha256: MagicBox<String>
```

10、字符串SHA384（返回16进制字符串）

```swift
public var sha384: MagicBox<String>
```

11、字符串SHA512（返回16进制字符串）

```swift
public var sha512: MagicBox<String>
```

12、字符串HMAC（返回16进制字符串）

```swift
public var hmac(type: MagicBox<Data>.HMACType, key: String) -> MagicBox<String>
```

13、将16进制字符串转成16进制Data

```swift
public var hexData: Data
```

14、将json字符串转成字典类型，例如：{"key1": "value1"}

```swift
public var jsonMap: [String: Any]?
```

15、将json字符串转成字典数组类型，例如：[{"key": "value"}, {"key": "value"}]

```swift
public var jsonMapArray: [[String: Any]]?
```

16、将json字符串转成数组类型，并指定数组元素类型。

```swift
public func jsonArray<T>(_ elementType: T.Type) -> [T]?
```

17、将json字符串转成指定类型

```swift
public func toJson<T>(_ type: T.Type) -> T?
```

18、去掉字符串两端空格和换行符

```swift
public var trim: MagicBox<String>
```

19、去掉字符串两端指定的字符串

```swift
public func trim(_ str: String) -> MagicBox<String>
```