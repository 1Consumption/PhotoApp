# PhotoApp

## PhotoListNetworking

### summary

모델을 서버에서 받아오고 디코드해서 handler로 넘겨주고, page 정보를 알고 있어서 모든 정보를 받아오지 않고 나눠서 받아올 수 있는 `PhotoListUseCase`

모델과 `PhotoListUseCase`을 소유하면서 모델의 변화를 바인딩할 수 있는 `PhotoListViewModel`



### `RemoteDataDecodableType`

 `retrieveModel<T: Decodable>(from:failureHandler:modelWillDeliverHandler:successHandler:)` 메소드는 서버에서 데이터를 받아오고 디코드 해주는 기본구현이 되어있다.([**RemoteDataDecodableType.swift**](https://github.com/1Consumption/PhotoApp/blob/feature/photoListNetworking/PhotoApp/PhotoApp/Common/RemoteDataDecodableType.swift)에서 확인 가능). 여기서  `modelWillDeliverHandler` 에 작업을 넘겨주면 모델이 전달되기 전에 원하는 작업을 수행할 수 있다.

``` swift
protocol RemoteDataDecodableType {
    var networkManager: NetworkManageable { get }
    
    func retrieveModel<T: Decodable>(from url: URL?,
                                     failureHandler: @escaping (UseCaseError) -> Void,
                                     modelWillDeliverHandler: (() -> Void)?,
                                     successHandler: @escaping (T) -> Void)
}
```

<br>

### `PhotoListUseCase`

먼저 `PhotoListUseCase`는 `RemoteDataDecodableType` 프로토콜을 채택한다. 아래는 `PhotoListUseCase`의 구현부 중 일부인데, 현재 페이지 정보를 저장하고 있다. 문제는 이 페이지 정보를 어떻게 변경할 것이냐인데, 모델이 전달되기 전(서버에서 온 데이터를 원하는 모델로 성공적으로 디코드 한 경우) page를 1 더해줘서 다음 요청은 다음 페이지에 대한 요청을 기대할 수 있다. 

``` swift
private(set) var page: Int = 1

func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping ([Photo]) -> Void) {
    let url = EndPoint(queryItems: .photoList(page: page)).url
    retrieveModel(from: url,
                  failureHandler: failureHandler,
                  modelWillDeliverHandler: { [weak self] in self?.page += 1 },
                  successHandler: successHandler)
}
```

아래와 같이 요청을 성공적으로 보내고 난 후 page의 값이 증가한 것을 볼 수 있다.

![image](https://user-images.githubusercontent.com/37682858/104032817-0d3e2e80-5212-11eb-8863-eb942af01214.png)

<br>

### `PhotoListViewModel`

`[Photo]` 타입의 `photoList` 프로퍼티를 가지고 있으며, 해당 프로퍼티가 변경되면 바인딩 되어있는 handler를 실행시켜 view가 알아차릴 수 있다. 현재는 모델이 append만 되기 때문에 별 다른 처리를 해주지 않았으나, 만약 insert, delete 작업이 추가 된다면 enum을 하나 만들어서 작업을 분리 후 handler에 전달해 줄 수 있다.

``` swift
private var photoList: [Photo] {
    didSet {
        let stardIndex = oldValue.count
        let endIndex = photoList.count
        handler?(stardIndex..<endIndex)
    }
}
```

그리고 `PhotoListUseCase` 타입의 `photoListUseCase`를 가지고 있다. 이 프로퍼티를 통해 서버에서 데이터를 받고, 디코드한 결과를 내려받고 `photoList`에 추가해준다.

```swift
func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void) {
    photoListUseCase.retrievePhotoList(failureHandler: failureHandler,
                                       successHandler: { [weak self] in
                                        self?.photoList.append(contentsOf: $0)
                                       })
}
```

결과적으로 아래의 흐름으로 핸들러가 실행된다.

1. 외부에서 `retrievePhotoList(failureHandler:) 메소드 호출`(이벤트 전달)
2. `photoListUseCase` 를 통해 디코딩된 모델을 `photoList`에 추가함
3.  `photoList`가 변경되면 변경된 index 범위를 handler를 통해 전달함

<img src = "https://user-images.githubusercontent.com/37682858/104035157-25fc1380-5215-11eb-89d9-3fab102d470f.png" width = "300">



### appendix

> @testable import의 이유?
>
> 접근제어자를 명시해주지 않으면 Internal이 되는데, Internal은 외부 모듈에서 접근이 불가능하다. 
>
> ![image](https://user-images.githubusercontent.com/37682858/104029025-c994f600-520c-11eb-808c-c2c1f2e7d12a.png)
>
> 따라서 프로덕트 모듈과 테스트 모듈은 별개이므로 테스트 모듈에서 프로덕트 모듈에 접근이 불가능하다는 말이다. 하지만, @testable 어노테이션을 명시해주면서 Internal로 지정된 객체에 접근이 가능하기 때문에 테스트를 할 수 있다.