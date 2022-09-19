//
//  MainViewController.swift
//  CatCat
//
//  Created by Ekko on 2022/09/11.
//

import UIKit
import Alamofire
import CHTCollectionViewWaterfallLayout
import SDWebImage

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //  .getCats로 가져온 데이터 저장할 배열
    var catArray = [Cats]()
    
    //  .getCats Parameter Variable
    var page: Int = 0
    var limit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad()")
        
        setUpCollectionView()
        requestAPI()
    }
    
    func setUpCollectionView() {
        
        //  Attach Datasource and Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //  Register nibs
        collectionView.register(UINib(nibName: "CatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CatsCollectionViewCell")
        
        //  Setup Layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: .GET Cat
    func requestAPI() {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = ImageRouter.getCats(limit: String(limit), page: String(page))
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseDecodable(of: [Cats].self) { response in
                    switch response.result {
                        
                    case .success(let result):
                        self.catArray.append(contentsOf: result)
                        //print(self.catArray)
                        self.collectionView.reloadData()
                        
                    case .failure(let error):
                        print("MainViewController - requestAPI() error", error.localizedDescription)
                    }
                }
        }
    }

}

//MARK: - CollectionView Delegate & DataSource
extension MainViewController: UICollectionViewDelegate {
    
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatsCollectionViewCell", for: indexPath) as? CatsCollectionViewCell {
            
            cell.cellDelegate = self
            
            cell.imformationLabel.text = "\(indexPath.row)번 Cell"
            
            cell.favoriteButton.tag = indexPath.row
            
            // Button image 변경
            // 버튼을 누르면 reloaditem하면서 버튼 색상이 변경됨.
            if catArray[indexPath.row].isFavorite == nil || catArray[indexPath.row].isFavorite == false {
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        
            //  Set catImage Using 'SDWebImage' Library
            cell.catImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            cell.catImage.sd_setImage(with: URL(string: catArray[indexPath.row].url))
            
            return cell
        }
        return UICollectionViewCell()
    }
}


//MARK: - CHTCollectionViewDelegateWaterfallLayout
extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = catArray[indexPath.row].width ?? 100
        let height = catArray[indexPath.row].height ?? 100
        
        return CGSize(width: width, height: height + 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
 
}

//MARK: - PostFavoriteCatDelegate - API .POST Call
extension MainViewController: PostFavoriteCatDelegate {
    
    /// Favorite Button이 눌렸을때 호출
    /// 선택한 버튼이 위치한 cell의 indexPath를 버튼의 tag로 설정 후
    /// catArray[indexPath.row]의 id를 즐겨찾기로 추가한다.
    func favoriteButtonPressed(indexPath: Int) {
        print("MainViewController - favoriteButtonPressed() called")
        print("MainViewController - \(indexPath)번째 Cell을 눌렀습니다.")
        print("MainViewController - \(catArray[indexPath].id)")
        
        if catArray[indexPath].isFavorite == false || catArray[indexPath].isFavorite == nil {
            favoritePostRequestAPI(imageId: catArray[indexPath].id, indexPath: indexPath) //  .POST API CALL
            catArray[indexPath].isFavorite = true
        } else {
            //  .DELETE API CALL
            favoriteDeleteRequestAPI(favourite_id: catArray[indexPath].favourite_id!) // 🚨 Optional 수정 필요 🚨 //
            catArray[indexPath].isFavorite = false
        }
        
        // 선택한 cell만 reload
        let indexPaths: [IndexPath] = [IndexPath(row: indexPath, section: 0)]
        self.collectionView.reloadItems(at: indexPaths)
    }

    
    //MARK: .POST Favorite
    func favoritePostRequestAPI(imageId: String, indexPath: Int) {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = FavoriteRouter.postFavorites(id: imageId)
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseDecodable(of: PostFavoriteResponse.self) { response in
                    switch response.result {
                    case.success(let result):
                        self.catArray[indexPath].favourite_id = String(result.id!) // 🚨 Optional 수정 필요 🚨 //
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
        }
    }
    
    
    //MARK: .DELETE Favorite
    func favoriteDeleteRequestAPI(favourite_id: String) {
        var urlToCall: URLRequestConvertible?

        urlToCall = FavoriteRouter.deleteFavorites(favourite_id: favourite_id)
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseData { response in
                    print(response)
                }
        }
    }
}

///  1. MainView Load
///  - cat request
///  - favorite cat request
///
///  2. press favorite button
///  - post favorite cat
///  - favorite cat request again ( 버튼 눌렀다가 취소하는 경우 request delete api ) -> favourite_id가 필요하기 favorite cat 재호출 필요

/// 2-1 (성공 )
///  ! favorite post response에 있는 favourite_id를 이용하는 방법 ?
///   - cat Model에 favorite_id라는 옵셔널 속성 주가
///   - if isFavorite 이라면 위의 속성을 넣어 delete favorite 함수 호출




///2022.09.19 수정 필요
///1. main에서 favorite get api를 호출해서 image_id를 가져온다.
///2. favorite get api에서 가져온 image_id가 image .get으로 가져온 image_id에 있는지 확인 후 isFavorite 속성 설정 후 reload 필요.
///
///3. collectionView refresh 추가 (feat. paging)
///
