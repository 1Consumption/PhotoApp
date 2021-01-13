# PhotoApp

## PhotoListBinding

### MVVM 구조 채택

<img width="1006" alt="image" src="https://user-images.githubusercontent.com/37682858/104054787-138fd300-5231-11eb-82e6-6462c3068593.png">

* View
  * ViewModel에게 이벤트를 전달. 
  * ViewModel을 관찰하고 있다가 ViewModel이 바뀌면 업데이트
* ViewModel
  * View에 대한 로직을 가지고 있음
  * Model을 소유하고 있음.
  * Model을 업데이트하고 Model이 바뀌면 변경사항을 방출
* Model
  * 데이터를 소유함
  * 데이터에 대한 비즈니스 로직을 가지고 있음.

<br>

### 왜 MVVM을 채택했는가?

1. 테스트의 용이성 및 ViewController 역할 분리

   * MVC 패턴은 View와 Controller가 서로 강하게 의존하고 있어서 Controller(view에 대한 로직) 부분을 테스트하기가 어려웠음. 하지만 MVVM의 경우는 ViewModel은 View에 대한 비즈니스 로직만 가지기 때문에 테스트할 수 있다.

   * View가 복잡해지면서 View에 대한 비즈니스 로직을 모두 ViewController에서 처리하기에는 너무 비대해짐. 따라서 이를 ViewModel로 역할을 나누어 ViewController가 비대해지는 것을 방지함. 하지만 ViewModel도 비대해질 수 있기 때문에, 설계에 각별한 주의가 필요하다.

2. View 업데이트 용이

   * MVC 패턴은 이벤트에 의해 ViewController가 Model을 업데이트하고, Model이 업데이트되면 ViewController에게 알려 ViewController가 View를 업데이트 하게 하였음.
   * 반면 MVVM 패턴은 View가 ViewModel을 관찰하고 있다가 ViewModel의 상태가 변하면 View가 업데이트하기 때문에 View 업데이트가 용이하다.

<br>

### 동작 예시

``` swift
final class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    ///...
    private let photoListViewModel: PhotoListViewModel = PhotoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      	///...
        photoListViewModel.bind({ range in
            DispatchQueue.main.async { [weak self] in
                self?.photoListCollectionView.insertItems(at: range.map { IndexPath(item: $0, section: 0)})
            }
        })
        
        photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                                self?.showErrorAlert(with: $0.message)})
    }
}
```

`PhotoListViewModel`을 `PhotoListViewController`에서 소유한다. 그리고 `PhotoListViewController`가 메모리에서 불리고 난 후, View와 ViewModel을 바인딩한다. 여기서는 새로 추가된 model에 대해 cell을 업데이트 해야 하기 때문에 `bind` 메소드 내에서 새로 추가된 model에 대한 cell을 삽입해줬음.

바인딩을 한 후 ViewModel에게 이벤트를 전달하여 서버에서 데이터를 받아오도록 함.

<br>

``` swift
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
    
    guard lastIndexPathItem < indexPath.item + 3 else { return }
    
    photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                            self?.showErrorAlert(with: $0.message)})
}
```

`UICollectonViewDelegate`의 메소드인 `collectionView(_:willDisplay:forItemAt:)` 메소드에서 특정 IndexPath가 전달되는 이벤트가 발생하면 ViewModel에게 다음 모델을 불러오라는 이벤트를 전달.
