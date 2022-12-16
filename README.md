CatCat
======
[The Cat API](https://thecatapi.com/)를 사용해 고양이 이미지를 보고, 즐겨찾기를 통해 저장하고, 내 고양이 사진을 업로드 하는 앱

### 스크린샷
<p align="left">
    <img src= "https://github.com/Ekko0701/CatCat/blob/main/CatCat/ScreenShots/Main.png" width="20%">
    <img src= "https://github.com/Ekko0701/CatCat/blob/main/CatCat/ScreenShots/Favorite.png" width="20%">
    <img src= "https://github.com/Ekko0701/CatCat/blob/main/CatCat/ScreenShots/My.png" width="20%">
    <img src= "https://github.com/Ekko0701/CatCat/blob/main/CatCat/ScreenShots/Upload.png" width="20%">
</p>

### 개발 상세 
#### Main 탭
* 고양이 이미지를 보여줌. (.GET)
* 하트 버튼 터치시 즐겨찾기 추가 및 해제 가능. (.POST)

#### Favorite 탭
* 즐겨찾기에 추가된 고양이 확인 가능 (.GET)
* 하트 버튼 터치시 즐겨찾기 추가 및 해제 가능. (.POST)

#### My 탭
* 사용자가 업로드한 고양이 사진 확인 가능 (.GET)
* 업로드 버튼 터치시 Camera 및 갤러리를 통해 고양이 이미지 업로드 가능 (POST(upload))
 
Features
--------
* ```Storybaord``` 사용
* ```MVC``` Architecture
* CollectionView ```Refresh``` 구현  
* CollectionView ```Infinity Scrolling``` 구현
* ```Alamofire```를 이용한 ```Restful API``` 사용 ( ```GET```, ```POST```, ```UPLOAD```)
* ```SDWebImage```를 사용해 URL Image 사용
* Pinterest UI를 참고해 CollectionView를 ```Waterfall Layout``` 방식으로 구현.
* 사용자의 이미지를 업로드 하기 위해 ```PHPicker```와 ```UIImagePickerController```를 사용
   
 <p align="left">
    <img src= "https://user-images.githubusercontent.com/108163842/192106023-bdf2335a-b3e1-4927-8934-7ffc9bf087af.gif" width="20%">
    <img src= "https://user-images.githubusercontent.com/108163842/192105064-0c85673a-774a-4221-aa9e-9882d097b3d4.gif" width="20%">
</p>


Open Source Library
--------------------
1. [Alamofire](https://github.com/Alamofire/Alamofire)  
Alamofire를 이용해 Restful API 통신을 했다. Routing 방식으로 Request를 구현하였다.  
2. [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)  
Pinterest와 같은 Waterfall Layout으로 이미지를 보여주기 위해 사용하였다.  
3. [SDWebImage](https://github.com/SDWebImage/SDWebImage)  

