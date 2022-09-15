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
            
            cell.imformationLabel.text = "\(indexPath.row)번 Cell"
            
            //  Set catImage Using 'SDWebImage' Library
            cell.catImage.sd_setImage(with: URL(string: catArray[indexPath.row].url), placeholderImage: UIImage(named: "placeholder\(indexPath.row).png"))
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let imageSize = catArray[indexPath.row].
        let width = catArray[indexPath.row].width
        let height = catArray[indexPath.row].height
        
        
        // 🚨 Optional 수정 필요 🚨 //
        return CGSize(width: width!, height: height! + 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
 
}



