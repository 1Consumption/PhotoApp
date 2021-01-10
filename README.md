# PhotoApp

## ImageCache

### summury

이전 브랜치에서는 서버에서 받아온 이미지를 cell에만 할당해줬다. 그 결과 cell이 재사용 될 때 이전 이미지는 사라지게 되었고, 사라진 이미지를 다시 불러오려면 서버에서 받아와야 하기 때문에 리소스 낭비가 있었다. 따라서 imageCache 브랜치에서는 Image caching을 담당하는 `ImageMaganger` 클래스를 구현하였고, `ImageManager` 클래스를 통해 collectionView의 cell에 이미지를 바인딩해 줬다. cell을 재사용해도 `ImageManager`의 `MemoryCacheStorage`에서 이미지를 가지고 있어서 리소스 낭비를 줄일 수 있었다.

<br>

<img width="1002" alt="image" src="https://user-images.githubusercontent.com/37682858/104103652-9fb00200-52e6-11eb-97b3-c056d6f58b60.png">

### `MemoryCacheStorage`

`MemoryCacheStorage` 클래스는 만료기한을 가지는 `ExpirableObject`를 캐싱한다. 삽입, 참조, 삭제 등의 기능을 수행할 수 있으며  이미지가 참조되면 만료기한을 초기화하는 동작을 한다.

#### `ExpirableObject`

아래 코드는 `ExpirableObject`의 구현부이다. 해당 오브젝트가 만들어질 때, 인자로 넘겨받은 시간 값과 현재 시간을 더해 만료 기한을 만들었다. 또한 `isExpired` 프로퍼티를 통해 만료 여부를 알 수 있으며, `resetExpectedExpireDate(_:)` 메소드를 통해 만료 기한을 초기화 할 수 있다.

```swift
final class ExpirableObject<T> {    
    let value: T
    private var expectedExpireDate: Date
    var isExpired: Bool {
        return Date() > expectedExpireDate
    }
    
    init(with value: T, expireTime: ExpireTime) {
        self.value = value
        expectedExpireDate = Date(timeIntervalSinceNow: expireTime.timeInterval)
    }
    
    func resetExpectedExpireDate(_ expireTime: ExpireTime) {
        expectedExpireDate = Date(timeIntervalSinceNow: expireTime.timeInterval)
    }
}
```

<br>

### `ImageManager`

`ImageManager`는 다음과 같은 순서로 이미지를 찾는다.

1. `MemeoryCacheStorage`에 key를 넘겨주고 key에 해당하는 이미지가 있는지 확인한다.

2. `MemeoryCacheStorage`는`cache`프로퍼티에서 key에 해당하는 이미지를 확인한다.

    1) 해당 이미지가 만료되었으면 해당 이미지를 `cache`에서 삭제하고 nil을 반환한다.

    2) 만료되지 않았다면 만료 시간을 초기화하고 handler를 통해 이미지를 외부에 넘겨준다.

3. 2번의 결과가 nil인 경우 로컬에 없다는 뜻이므로 `NetworkManageable`을 사용해 서버에서 이미지를 받아온다.

4. 서버에서 이미지를 받아오면 `MemeoryCacheStorage`에 이미지를 저장하고 handler를 통해 이미지를 외부에 넘겨준다.

<br>

### 트러블 슈팅

#### 배경

<img src = "https://user-images.githubusercontent.com/37682858/104105187-cde60f80-52ef-11eb-94ba-e6d9945b3661.gif" width = "300">

`photoListCollectionView`를 빠르게 스크롤하면 cell에 알맞는 이미지가 들어가지 않고 다른 cell의 이미지와 충돌하여 바뀌는 현상이 발생함.

#### 원인

``` swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  	///...
    ImageManager.shared.retrieveImage(from: photo.urls.regular) { image in
        DispatchQueue.main.async {
            cell.photoImageView.image = image
        }
    }
    
    return cell
}
```

위 코드는 `photoListCollectionViewDataSource`의 `cellForItemAt` 메소드이다. A 셀이 있다고 가정하고, 이 A 셀을 재사용한다고 생각해보자. 아래와 같은 문제가 발생하게 된다.

![셀 재사용 이슈](https://user-images.githubusercontent.com/37682858/104114543-07973480-5349-11eb-8d6f-9652f8c1df83.gif)

1.  `cellForItemAt` 메소드에서 Image A 요청을 한다.
2. Image A에 대한 응답이 오기 전에 셀이 재사용 된다.
3. 재사용된 셀이 Image B 요청을 한다.
4. 재사용되기 전에 보냈던 Image A 응답이 도착한다. 이를 셀에 반영한다.
5. 재사용된 셀에 대한 Image B 응답이 도착한다. 이를 셀에 반영한다.

즉 이전 요청을 처리하지 않고 모두 응답을 받아서 반영하기 때문에 발생한 문제이다.

#### 해결

``` swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  	///...
    let photoViewModel = PhotoViewModel(photo: photo)
    
    cell.bind(photoViewModel)

    return cell
}
```

먼저  `cellForItemAt` 메소드를 변경했다.  `cellForItemAt` 메소드에서 이미지 요청을 보내는 것이 아닌 cell에 대한 뷰모델을 만들어서 주입해준다. 이렇게 되면 cell의 재사용과 관련 없이 매번 새로운 `PhotoViewModel`이 만들어진다.

<br>

```swift
final class PhotoListCollectionViewCell: UICollectionViewCell {
  	///...
    private var viewModel: PhotoViewModel?
  
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        authorNameLabel.text = viewModel?.photo.user.name
        viewModel?.bind { [weak self] image in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
            }
        }
        viewModel?.retrieveImage()
    }
  	///...
}
```

그리고 셀의 내부에서 `PhotoViewModel`과 `photoImageView` 를 바인딩해 준다. `PhotoViewModel`에서 값이 방출되면 `photoImageView`은 업데이트를 할 것이다. `PhotoViewModel`이 사라지면 해당 핸들러도 실행되지 않는다는 점이다. 즉 셀이 재사용될 때마다 `PhotoViewModel`을 새로 주입해주기 때문에 cell 재사용 시 이전 이미지 요청에 대한 이슈를 없앨 수 있었다.