# PhotoApp

## 목차

* [브랜치별 핵심 구현 내용](#브랜치별-핵심-구현-내용)
* [기능](#기능)

> Common 폴더에 Secret.swift 파일을 만들고 API키를 삽입 해야 앱 실행 가능.

## 브랜치별 핵심 구현 내용

* networkManager - [네트워킹 객체 구현](https://github.com/1Consumption/PhotoApp/tree/feature/networkManger/README.md)
* photoListNetworking - [사진 목록 화면 네트워킹(PhotoListViewModel 구현)](https://github.com/1Consumption/PhotoApp/tree/feature/photoListNetworking/README.md)
* photoListBinding - [MVVM 구조 채택](https://github.com/1Consumption/PhotoApp/tree/feature/photoListBinding/README.md)
* imageCache - [이미지 메모리 캐싱, 셀 재사용 이슈 해결](https://github.com/1Consumption/PhotoApp/tree/feature/imageCache/README.md)
* photoDetailView - [1:N 바인딩 구현](https://github.com/1Consumption/PhotoApp/tree/feature/photoDetailView/README.md)
* searchPhoto - [ViewModelType 프로토콜 구현](https://github.com/1Consumption/PhotoApp/tree/feature/searchPhoto/README.md)

## 기능

### 사진 리스트 화면

사진 리스트를 받아와서 스크롤할 수 있다. 스크롤이 마지막에 도달하면 다음 사진 리스트를 받아온다.

<img src = "https://github.com/1Consumption/PhotoApp/blob/main/Images/photoListScroll.gif">

<br>

### 사진 상세 화면

사진을 터치하면 사진을 하나만 볼 수 있는 상세화면으로 들어간다. 좌우로 스크롤하여 사진을 넘길 수 있으며, 닫기 버튼을 터치하면 마지막으로 본 사진이 보인다.

<img src = "https://github.com/1Consumption/PhotoApp/blob/main/Images/detailView.gif">

<br>



### 검색 기능

상단 바를 통해 검색을 할 수 있다. 검색 결과가 없는 경우 No Results를 보여주고, 검색 결과가 있다면 사진 리스트를 보여준다. 기능은 사진 동일하다. 

<div>

<img src = "https://github.com/1Consumption/PhotoApp/blob/main/Images/search.gif">

<img src = "https://github.com/1Consumption/PhotoApp/blob/main/Images/searchNoResult.gif">

</div>

<br>

## 검색 종료

상단 cancel 버튼을 누르면 검색 리스트를 보이지 않고 사진 리스트를 보인다.

<img src = "https://github.com/1Consumption/PhotoApp/blob/main/Images/searchEnd.gif">