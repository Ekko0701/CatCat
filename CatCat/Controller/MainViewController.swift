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
        
        let width = catArray[indexPath.row].width
        let height = catArray[indexPath.row].height
        
        
        // 🚨 Optional 수정 필요 🚨 //
        return CGSize(width: width!, height: height! + 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
 
}

//MARK: - PostFavoriteCatDelegate - API .POST Call
extension MainViewController: PostFavoriteCatDelegate {
    func favoriteButtonPressed(indexPath: Int) {
        print("MainViewController - favoriteButtonPressed() called")
        print("MainViewController - \(indexPath)번째 Cell을 눌렀습니다.")
        print("MainViewController - \(catArray[indexPath].id)")
        
        favoritePostRequestAPI(imageId: catArray[indexPath].id)
    }
    
//    func favoriteButtonPressed() {
//        print("MainViewController - favoriteButtonPressed() called")
//        favoritePostRequestAPI(imageId: "d0j")
//    }
    
    func favoritePostRequestAPI(imageId: String) {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = FavoriteRouter.postFavorites(id: imageId)
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseData { response in
                debugPrint(response)
            }
        }
    }
}
