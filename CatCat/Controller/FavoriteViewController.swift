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
    
    var imageViewForSize = UIImageView()    // 📌 Test
    var imageForSize = UIImage() // 📌 Test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FavoriteViewController - viewDidLoad()")
        setUpCollectionView()
        requestAPI()
    }

    func setUpCollectionView() {
        
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
                        
                        self.favoriteCatArray.append(contentsOf: result)
                        self.collectionView.reloadData()
                        
                    case .failure(let error):
                        print("FavoriteViewController - requestAPI() error", error.localizedDescription)
                    }
                
                }
        }
    }
    
    // 📌 Test
    //  https://medium.com/geekculture/find-image-dimensions-from-url-in-ios-swift-a186297e9922
//    func imageDimenssions(url: String) -> String {
//
//    }
    
    // 📌 Test
    // url의 image 사이즈를 반환하는 메소드
    func sizeOfImageAt(url: URL) -> CGSize? {
        // with CGImageSource we avoid loading the whole image into memory
    
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
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
            
            cell.catImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            cell.catImage.sd_setImage(with: URL(string: favoriteCatArray[indexPath.row].image.url)) { (image, error, _, _) in
                if (error != nil) {
                    cell.catImage.image = UIImage(systemName: "circles.hexagonpath.fill")
                } else {
                    print("성공 - \(image?.size)")
                    cell.catImage.image = image
                    self.favoriteCatArray[indexPath.row].image.width = 500
                    self.favoriteCatArray[indexPath.row].image.height = image?.size.height
                }
            }
            
//            cell.catImage.sd_setImage(with: URL(string: favoriteCatArray[indexPath.row].image.url)) { (image, err, type, url) in
//
//                // 🚨 Optional 수정 필요 🚨 //
//                self.favoriteCatArray[indexPath.row].image.width = image?.size.width
//                self.favoriteCatArray[indexPath.row].image.height = image?.size.height
//
//                print("UICollectionViewDataSource - \(self.favoriteCatArray)")
//            }
            
//            cell.catImage.sd_setImage(with: URL(string: favoriteCatArray[indexPath.row].image.url)) { (image, Error, _, _) in
//                //print("이미지 사이즈 입니다. \(image!.size)")
//                // 🚨 Optional 수정 필요 🚨 //
//                self.favoriteCatArray[indexPath.row].image.width = image?.size.width
//                self.favoriteCatArray[indexPath.row].image.height = image?.size.height
//            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension FavoriteViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 🚨 Optional 수정 필요 🚨 //
        let width = favoriteCatArray[indexPath.row].image.width ?? 100
        let height = favoriteCatArray[indexPath.row].image.height ?? 100
        
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}
