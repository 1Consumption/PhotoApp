# PhotoApp

## SearchPhoto

### summary

사용자가 검색어를 입력하면 해당 검색어에 맞는 사진을 받아오는 기능을 구현했다. 여기서 사진 검색에 해당하는 viewModel에 전달되는 이벤트가 너무 많아졌다. 따라서 ViewModel의 input과 output을 정의하여 viewModel 내부에서 input의 결과를 가공해 output으로 보내면 view는 이것을 보고 업데이트를 할 수 있게 하였다.

<br>

### `ViewModelType`- Input / Output 

기존 뷰모델은 `Observerble`을 하나씩만 들고 있었다. 즉 받는 이벤트가 한가지 종류였다. 그런데 검색 기능에 대한 이벤트는 한가지 종류가 아닌 아래와 같이 여러가지이다.

1. textField가 눌렸을 때
2. cancel 버튼이 눌렸을 때
3. 전송 버튼이 눌렸을 때
4. 다음 사진 리스트를 받아와야 할 때

이러한 이벤트들이 많아지면서 관리하기가 복잡해졌다. 하나의 이벤트의 결과에 대해 여러 객체의 상태가 변해야할 수도 있기 때문이다(ex: 네트워크에 대한 결과는 실패할수도, 성공할수도 있고, 성공에 대한 결과도 값이 비어있는지 또는 비어있지 않은지 등). 

이를 `ViewModelType`을 만들어 채택하게 하여 이벤트를 효과적으로 관리할 수 있었다.

``` swift
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var bag: CancellableBag { get }
    
    func transform(input: Input) -> Output
}
```

`ViewModelType`은 `Input` 타입을 받아 `Output` 타입을 반환해준다.

``` swift
struct SearchViewModelInput: SendEventType {
    let textFieldEditBegan: Observable<Void> = Observable<Void>()
    let cancelButtonPushed: Observable<Void> = Observable<Void>()
    let sendQuery: Observable<String> = Observable<String>()
    let sendEvent: Observable<Void> = Observable<Void>()
}

struct SearchViewModelOutput: DeliverInsertedIndexPathType {
    let textFieldEditBegan: Observable<Bool> = Observable<Bool>()
    let cancelButtonPushed: Observable<Bool> = Observable<Bool>()
    let errorOccurred: Observable<UseCaseError> = Observable<UseCaseError>()
    let isResultsExist: Observable<Bool> = Observable<Bool>()
    let changedIndexPath: Observable<[IndexPath]> = Observable<[IndexPath]>()
}

final class SearchViewModel: ViewModelType {
	//...
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.textFieldEditBegan.bind { [weak self] _ in
        //...
        }.store(in: &bag)
        
        input.cancelButtonPushed.bind { _ in
        //...
        }.store(in: &bag)
        
        input.sendQuery.bind { [weak self] in
        //...
        }.store(in: &bag)
        
        input.sendEvent.bind { [weak self] _ in
        //...
        }.store(in: &bag)
    
        return output
    }
}
```

`ViewModel`은 외부에서 전달된 `Input` 타입에 대한 동작(모델 가공 로직)을 `transfrom(input:)` 메소드에서 정의하고 바인딩 한다. 그리고 이벤트에 대한 동작이 정의되어 있는 `Output` 타입을 반환한다. 이 `Output` 타입을 view가 관찰하고 업데이트한다.

``` swift
// PhotoListViewController
private let searchViewModel: SearchViewModel = SearchViewModel()
private let searchViewModelInput: SearchViewModelInput = SearchViewModelInput()

private func bindSearchView() {
    searchViewModelOutput = searchViewModel.transform(input: searchViewModelInput)
    
    searchViewModelOutput?.textFieldEditBegan.bind { [weak self] in
        guard let hiddenFactor = $0 else { return }
        self?.animate { [weak self] in
            self?.searchCancelButton.isHidden = hiddenFactor
        }
    }.store(in: &bag)
  	
    // bindings...
}

//...

extension PhotoListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchViewModelInput.textFieldEditBegan.fire()
    }
}
```

이를 사용한 예시이다. view는 viewModel의 `Input` 타입을 프로퍼티로 가지고 있고, 해당 viewModel의 `transform(input:)` 메소드를 통해 `Output` 타입을 받고 원하는 동작을 정의한다. 이 예시의 경우 `UITextField`가 수정되기 시작하면(터치 되면) viewModel에게 `textFieldEditBegan` 이벤트를 보낸다. 그러면 viewModel은 내부에서 `Input`과 바인딩된 로직을 실행하고 `Output`을 방출한다. `Output`을 관찰하고 있던 `searchCancelButton`은 상태의 변경에 맞게 자신의 상태를 변경할 수 있다.