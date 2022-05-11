## Foundation

### 一、String

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

3、对字符串进行URLEncoding编码

```swift
public var urlEncoding: MagicBox<String>
```

