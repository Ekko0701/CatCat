//
//  FavoriteViewController.swift
//  CatCat
//
//  Created by Ekko on 2022/09/11.
//

import UIKit
import Alamofire
import CHTCollectionViewWaterfallLayout
import SDWebImage
import SwiftUI

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteCatArray = [FavoriteCats]()
    
    var imageViewForSize = UIImageView()
    var imageForSize = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FavoriteViewController - viewDidLoad()")
        setUpView()
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("FavoriteViewController - viewWillAppear()")
        requestAPI()
    }
    
    func setUpView() {
        view.backgroundColor = .bgBlack
    }
    
    func setUpCollectionView() {
        collectionView.backgroundColor = .bgBlack
        
        //  Attach Delegate and DataSourde
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //  Register nibs
        collectionView.register(UINib(nibName: "FavoriteCatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CELL_IDENTIFIER.FAVORITE_CELL)
        
        //  Setup Layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        self.collectionView.collectionViewLayout = layout
    }
    
    //MARK: .GET Favourite
    func requestAPI() {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = FavoriteRouter.getFavorites
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseDecodable(of: [FavoriteCats].self){ response in
                    switch response.result {
                        
                    case .success(let result):
                        self.favoriteCatArray.removeAll()
                        self.favoriteCatArray.append(contentsOf: result)
                        self.collectionView.reloadData()
                        
                    case .failure(let error):
                        print("FavoriteViewController - requestAPI() error", error.localizedDescription)
                    }
                
                }
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCatArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.FAVORITE_CELL, for: indexPath) as? FavoriteCatsCollectionViewCell {
            
            // Attach Delegate
            cell.cellDelegate = self
            
            cell.favoriteButton.tag = indexPath.row //favoriteCatArray 인덱스 접근을 위해 버튼 태그 설정
            
            if favoriteCatArray[indexPath.row].isFavorite == nil || favoriteCatArray[indexPath.row].isFavorite == true {
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
            // Set Image Indicator
            cell.catImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            // Check Url Image Size
            cell.catImage.sd_setImage(with: URL(string: favoriteCatArray[indexPath.row].image.url)) { (image, error, _, _) in
                if (error != nil) {
                    cell.catImage.image = UIImage(systemName: "circles.hexagonpath.fill")
                } else {
                    cell.catImage.image = image
                    self.favoriteCatArray[indexPath.row].image.width = image?.size.width
                    self.favoriteCatArray[indexPath.row].image.height = image?.size.height
                }
            }
         
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension FavoriteViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}

extension FavoriteViewController: FavoriteDelegate {
    func favoriteButtonPressed(indexPath: Int) {
        print("FavoriteViewController - favoriteButtonPressed()")
        
        if favoriteCatArray[indexPath].isFavorite == true || favoriteCatArray[indexPath].isFavorite == nil {
            // .Delete
            favoriteDeleteRequestAPI(favourite_id: String(favoriteCatArray[indexPath].id))
            favoriteCatArray[indexPath].isFavorite = false
        } else {
            //  .POST
            favoritePostRequestAPI(imageId: favoriteCatArray[indexPath].image_id)
            favoriteCatArray[indexPath].isFavorite = true
        }
        
        
        // 선택한 cell만 reload
        let indexPaths: [IndexPath] = [IndexPath(row: indexPath, section: 0)]
        self.collectionView.reloadItems(at: indexPaths)
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
                    print("FavoriteViewController - favoriteDeleteRequestAPI Called")
                    print(response)
                }
        }
    }
    
    //MARK: .POST Favorite
    func favoritePostRequestAPI(imageId: String) {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = FavoriteRouter.postFavorites(id: imageId)
        
        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(urlConvertible)
                .validate()
                .responseDecodable(of: PostFavoriteResponse.self) { response in
                    print("FavoriteViewController - .POST requeest called")
                }
        }
    }
}
