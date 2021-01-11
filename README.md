# PhotoApp

## PhotoDetailView

### summary

사진 리스트 화면(`PhotoListViewController`)에서 보던 사진을 클릭하면 사진 상세 화면(`PhotoDetailViewController`)으로 전환한다. 이 상세 화면의 기능은 다음과 같다. 

1. 사진을 좌우로 스와이프하여 한 장씩 사진을 넘길 수 있다.
2. 현재 페이지의 끝 사진에 도달하면 다음 페이지에 해당하는 사진 정보를 받아올 수 있다. 
3. 상세화면을 닫으면 사진 리스트 화면으로 돌아가는데, 상세화면에서 마지막으로 본 사진이 목록에 나타나야 한다.

따라서 사진정보를 가지고 있는 `PhotoListViewModel`을 `PhotoListColletionViewDataSource`와 `PhotoDetailColletionViewDataSource`가 공유하게 해서 상세 화면과 리스트 화면의 모델을 동기화했고, delegate 패턴을 통해 상세 화면 마지막으로 본 사진이 리스트 화면에서도 보일 수 있게 처리했다.

<br>

### `PhotoListViewModel` 공유

`PhotoListViewModel` 의 역할은 이벤트가 발생하면 사진 모델을 받아오고, 추가된 범위를 방출한다. 이를 View들이 관찰하고 있다가 업데이트하는 방식이다. 그런데 왜 `PhotoListViewModel`을 공유했을까? 상세 화면에서 불러온 다음 페이지에 해당하는 사진 모델들도 사진 리스트 화면에 반영이 되어야 하기 때문이다. 즉, `PhotoListCollectionView`와 `PhotoDetailCollectionView`를 동기화 해야 한다.

따라서 하나의 뷰모델을 여러 개의 뷰가 관찰하도록 하고, 변화가 일어나면 관찰하고 있던 뷰들이 상태를 업데이트할 수 있도록 바인딩을 해줬다. 구조는 아래와 같다.

<img width="1246" alt="image" src="https://user-images.githubusercontent.com/37682858/104149704-a2ac0f00-541a-11eb-8e6a-7dcce60a15b3.png">

<br>

### Observable 리팩토링

``` swift
/// 기존 Observable
final class Observable<T> {
    typealias Handler = ((T?) -> Void)

    private var handler: Handler?
    var value: T? {
        didSet {
            handler?(value)
        }
    }
    
    func bind(_ handler: Handler?) {
        self.handler = handler
    }
}
```

그런데 기존의 `Observable` 클래스는 1:1 바인딩에 적합한 구조이다. 한 번에 하나의 동작만 저장하고 실행할 수 있기 때문이다. 

현재 하나의 `Observable`을  여러개의 view와 바인딩을 해줘야 하는 상황이나, 1:N 바인딩이 불가능하기 때문에 아래와 같이 리팩토링했다.

<br>

``` swift
typealias CancellableBag = Set<Cancellable>

final class Cancellable {
    private let cancelHandler: () -> Void
    
    init(_ cancelHandler: @escaping () -> Void) {
        self.cancelHandler = cancelHandler
    }
    
    deinit {
        cancelHandler()
    }
    
    func store(in bag: inout CancellableBag) {
        bag.insert(self)
    }
    
    func cancel() {
        cancelHandler()
    }
}
```

이에 앞서 `Cancellable` 클래스를 만들었는데, 하나의 `Observable`이 여러 뷰와 바인딩 되어 있는 도중 하나의 뷰가 바인딩을 끊고 싶을 때 해당 클래스를 통해 끊을 수 있도록 하기 위함이다.  `Cancellable` 클래스는 생성자에서 클로저를 받아 `cancel()` 메소드가 호출되거나 메모리에서 해제될 때 해당 클로저를 실행한다. 또한 `store(in:)` 메소드를 통해 자기 자신을 매개변수에 저장할 수 있다. 

<br>

```swift
/// 변경된 Observable
final class Observable<T> {
    typealias Handler = (T?) -> Void

    private var observers: [UUID: Handler?] = [:]
    
    var value: T? {
        didSet {
            observers.values.forEach {
                $0?(value)
            }
        }
    }
    
    func bind(_ handler: Handler?) -> Cancellable {
        let id = UUID()
        observers[id] = handler
        
        let cancellable = Cancellable { [weak self] in
            self?.observers[id] = nil
        }
        
        return cancellable
    }
}
```

`observser` 프로퍼티가 추가되었다. 이 프로퍼티는 동작에 고유한 id 값을 부여해서 관리한다. 동작 별로 id 값을 부여한 이유는 하나의 옵저버블에 A, B가 바인딩 되어있는데, B가 바인딩을 끊었을 때 B의 동작을 제거해주기 위함이다.

 `bind(_:) -> Cancellable` 메소드 내부의 동작은 다음과 같다.

1. `observers`에 고유한 `id` 값을 key로 `handler`를 등록한다.
2. `id`에 해당하는 `handler `를 `observers`에서 삭제하는 클로저를 `Cancellable`에 생성자로 넘겨준다.
3. 생성된 `Cancellable`을 반환한다.

여기서 반환된 `Cancellalbe`을 저장하지 않는다면 어떻게 될까? 

1. 해당 `Cancellalbe`의 참조 카운트는 0이 될 것이므로 메모리에서 해제된다.
2. `Cancellable`의 deinit이 실행되면서 `cancelHandler`가 실행된다.
3. `observers`에서 해당 동작이 삭제된다.

따라서 바인딩을 유지하고자 한다면 다음과 같이 `Cancellable`을 어딘가에 저장해놓아야 한다. 여기서 `PhotoViewModel`이 메모리에서 해제된다는 것은 `bag` 도 해제가 된다는 것이고, `bag`이 해제가 된다는 것은 내부의 `Cancellable`도 해제가 된다는 말이다. 즉 `PhotoViewModel`이 해제가 된다면 이와 바인딩 되어있던 동작들도 해제가 된다는 것을 의미한다.

``` swift
final class PhotoViewModel {
  	///...
    private var bag: CancellableBag = CancellableBag()

  	///...
    func bind(_ handler: @escaping ((UIImage?) -> Void)) {
        image.bind(handler)
            .store(in: &bag)
    }
}
```

<br>

위와 같이 리팩토링한 결과 1:N 바인딩을 안정적으로 할 수 있었다.

<br>

### appendix

navigation controller의 status bar color는 직접 바꿀 수 없다. 다만, 이를 `barStyle` 프로퍼티를 변경해서 바꿀 수 있다.

즉 `barStyle` 프로퍼티 `preferredStatusBarStyle`을 결정한다.

```swift
self.navigationController!.navigationBar.barStyle = .black
```

