## UIKit

### 一、CGRect

对CGRect的操作，返回修改后的CGRect的包装类，你可以采用链式调用，若要取出修改后的CGRect，调用包装类的value属性。例如：修改CGRect的x坐标和宽高，并将修改后的CGRect赋值给view：

```swift
let view = UIView()
view.frame = view.frame.mg.setX(20).setSize(width: 100, height: 40).value
```

1、修改CGRect的x坐标

```swift
public func setX(_ x: CGFloat) -> MagicBox<CGRect>
```

2、修改CGRect的y坐标

```swift
public func setY(_ y: CGFloat) -> MagicBox<CGRect>
```

3、修改CGRect的xy坐标

```swift
public func setXY(x: CGFloat, y: CGFloat) -> MagicBox<CGRect>
public func setXY(point: CGPoint) -> MagicBox<CGRect>
```

4、修改CGRect的宽

```swift
public setWidth(_ width: CGFloat) -> MagicBox<CGRect>
```

5、修改CGRect的高

```swift
public setHeight(_ height: CGFloat) -> MagicBox<CGRect>
```

6、修改CGRect的size

```swift
public setSize(width: CGFloat, height: CGFloat) -> MagicBox<CGRect>
public setSize(_ size: CGSize) -> MagicBox<CGRect>
```

7、为CGRect做偏移，可以在x和y轴进行偏移。例如：对CGRect(x: 10, y: 20, width: 100, height: 50)进行偏移，x偏移10，y偏移5，偏移后的CGRect为：CGRect(x: 20, y: 25, width: 100, height: 50)

```swift
public func offsetBy(dx: CGFloat, dy: CGFloat) -> MagicBox<CGRect>
```

8、为CGRect增加内边距。例如：对CGRect(x: 10, y: 20, width: 100, height: 50)添加内边距，x轴水平方向左右内边距为10，y轴垂直方向上下内边距为10，之后的CGRect为：CGRect(x: 20, y: 30, width: 80, height: 30)

```swift
CGRect(x: 10, y: 20, width: 100, height: 50).mg.insetBy(dx: 10, dy: 10)
```

```swift
public func insetBy(dx: CGFloat, dy: CGFloat) -> MagicBox<CGRect>
public func inset(by edge: UIEdgeInsets) -> MagicBox<CGRect>
```

