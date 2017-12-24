# XCTestExtensions
`XCTestExtensions` is a Swift extension that provides `XCTAssertEventually` (that convenient assertions  for writing Unit Test).

Use `XCTAssertEventually`, you can write asynchronous assertions very easily and intuitively, like [Nimble](https://github.com/Quick/Nimble)'s toEventually.

# Installation
## Installing with Carthage

Add to `Cartfile.private`
```
github "shindyu/XCTestExtensions"
```

# Usage
Import `XCTestExtensions` to Unit tests files:
```swift
import XCTestExtensions
```


Use `XCTestExtensions`'s extensions in your tests:
<img src="https://raw.githubusercontent.com/shindyu/XCTestExtensions/master/img/method_completion.png">


For example, Applying it to [the asynchronous test of the official document of apple](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations), it can be described as follows:
```swift
    func testDownloadWebData_UsingXCTAssertEventually() {
        let url = URL(string: "https://apple.com")!

        var downloadData: Data?

        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            downloadData = data
        }

        dataTask.resume()

        XCTAssertNotNilEventually(downloadData)
    }
```

# Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/shindyu/XCTestExtensions

# License
XCTestExtensions is available as open source under the terms of the [MIT License](https://github.com/shindyu/XCTestExtensions/blob/master/LICENSE).
