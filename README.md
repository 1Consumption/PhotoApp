# PhotoApp

## NetworkManager

네트워킹 기능을 구현한 브랜치이며, 핵심은 프로토콜을 통해 테스트가 가능하고 유연한 네트워킹 객체를 만들었다는 것에 있다.

두 가지 프로토콜을 정의했는데, `Requestable`과 `NetworkManageable` 프로토콜이다. 그리고, 이 프로토콜을 조합해 만든 `NetworkManager` 클래스를 통해 네트워킹을 할 수 있다.

###  `Requestable`

``` swift
protocol Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
```

URLRequest와 네트워킹을 끝내면 실행할 completionHandler를 매개변수로 받고, URLSessionDataTask를 반환해 원한다면 취소할 수 있다. 이 프로토콜을 채택한 객체는 `dataTask(with:completionHandler:) -> URLSessionDataTask` 메소드만 구현하면 된다. 즉 내부가 어떻게 구현이 되어있건 매개변수와 반환값을 지키면 해당 프로토콜을 채택하는 데는 문제가 없다. 

따라서 아래와 같이 원하는 케이스를 생성해 테스트를 할 수 있음. 특히 네트워크 테스트의 경우는 실패하는 케이스가 여러 개이고, 상황을 만들기 어렵기 때문에 더욱 효과적이다.

``` swift
// 항상 성공하는 네트워크 요청
final class SuccessRequester: Requestable {
    private let data: Data
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

// 항상 실패하는 네트워크 요청, NetworkError를 바꿔서 보낼 수 있다.
final class RequestErrorRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestError(description: "error"))
        return URLSession.shared.dataTask(with: urlRequest)
    }
}
```

<br>

###  `NetworkManageable`

``` swift
typealias DataResultHandler = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable: class {
    var requester: Requestable { get }
    
    @discardableResult
    func requestData(from url: URL?, ispermitDuplicate: Bool, method: HTTPMethod, header: [HTTPHeader]?, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask?
    
    func requestCompleted(with url: URLRequest, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler)
}

```

`requester`: 실질적으로 네트워킹을 담당하는 프로퍼티. `Requestable` 프로토콜을 채택하였음.

`requestData(from:isPermitDuplicate:method:header:completionHandler:) -> URLSessionDataTask?`: 외부에서 주입받은 `Requestable`을 채택한 `requester` 프로퍼티를 활용해 네트워킹을 하도록 의도된 메소드. 이 메소드에서 url의 유효성, 네트워크 오류 등을 체크하고 completionHandler에 값을 넘겨줌. 



### `NetworkManager.Swift` 

네트워킹을 하는 구현체. 생성자에서 `Requestable`을 채택한 타입을 받기 때문에 유연한 확장이 가능하다.(해당 프로토콜만 만족하면 어떤 객체든 올 수 있기 때문). 아무 값을 지정해주지 않으면 `URLSession.shared`를 통해 네트워킹을하게 된다.

``` swift
init(requester: Requestable = DefaultRequester()) {
    self.requester = requester
}

final class DefaultRequester: Requestable {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    }
}
```



`requestData(from:method:header:completionHandler:) -> URLSessionDataTask?` 내부에서 중복된 리퀘스트를 검사하는데, 코드는 다음과 같다. `isLoading`이 true 라면(아직 해당 요청에 대한 답이 오지 않았다면) 에러를 포함한 completionHandler를 실행하고 early exit 한다. 반대로 `isLoading`이 false라면 해당 요청은 중복되지 않은 요청이라고 간주하여 서버에 요청을 보내게 된다. 또한 매개변수로 받은 `isPermitDuplicate`를 통해 중복 허용을 해줄 수 있다.

``` swift
if isPermitDuplicate == false {
    guard !isLoading else {
        completionHandler(.failure(.duplicatedRequest))
        return nil
    }
    isLoading = true
}
```

<br>

그렇다면 `isLoading`은 언제 flase가 될까? 바로 completionHandler가 실행되기 전이다. completionHandler가 실행되었다는 것은 실패했던, 성공했던 서버로부터 응답이 왔다는 얘기이기 때문이다.(url오류나 중복 요청 오류 제외)

``` swift
func requestCompleted(with url: URLRequest, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler) {
    isLoading = false
    handler(result)
}
```



이 기능들을 사용해 아래와 같이 중복 테스트를 통과할 수 있었다.

![image](https://user-images.githubusercontent.com/37682858/104487439-71952f80-5610-11eb-9bea-e833826336da.png)
