CatCat
======
[The Cat API](https://thecatapi.com/)를 사용해 고양이 이미지를 보고, 즐겨찾기를 통해 저장하고, 내 고양이 사진을 업로드 하는 앱


### Cats 탭
* 고양이 이미지를 보여줌. (.GET)
* 하트 버튼 터치시 즐겨찾기 추가 및 해제 가능. (.POST)

### Favorite 탭
* 즐겨찾기에 추가된 고양이 확인 가능 (.GET)
* 하트 버튼 터치시 즐겨찾기 추가 및 해제 가능. (.POST)

### My 탭
* 사용자가 업로드한 고양이 사진 확인 가능 (.GET)
* 업로드 버튼 터치시 Camera 및 갤러리를 통해 고양이 이미지 업로드 가능 (POST(upload))
 
Features
--------
* ```Storybaord``` 사용
* ```MVC```
* CollectionView ```Refresh``` 구현.  
   
<img width = "200" src = "https://user-images.githubusercontent.com/108163842/192106023-bdf2335a-b3e1-4927-8934-7ffc9bf087af.gif">


* CollectionView **Infinite Scrolling** 구현  

<img width = "200" src = "https://user-images.githubusercontent.com/108163842/192105064-0c85673a-774a-4221-aa9e-9882d097b3d4.gif">
    
      
* Image Upload를 위해 UIImagePickerController()대신에 더 간결한 PHPicker를 사용함
* PHPicker는 카메라를 지원하지 않기 때문에 UIImagePickerController도 사용함.


Open Source Library
--------------------
1. [Alamofire](https://github.com/Alamofire/Alamofire)  
Alamofire를 이용해 Restful API 통신을 했다. Routing 방식으로 Request를 구현하였다.  
2. [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)  
Pinterest와 같은 Waterfall Layout으로 이미지를 보여주기 위해 사용하였다.  
3. [SDWebImage](https://github.com/SDWebImage/SDWebImage)  
URL image를 UIImageView에 세팅하기 위해 사용했다. 비슷한 다른 라이브러리와 다르게 Objective-c로 구현되어 있어 속도가 빠르다. 
