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
    var page: Int = 1
    var limit: Int = 10
    
    //  Refresh Control
    private var refreshControl = UIRefreshControl()
    private var isRefreshing = false
    
    //  Infinite Scrolling
    var isLoading = false
    var loadingView: IndicatorCollectionReusableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad()")
        
        setUpCollectionView()
        requestAPI(requestPage: page)
    }
    
    func setUpCollectionView() {
        
        //  Attach Datasource and Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //  Register nibs
        collectionView.register(UINib(nibName: "CatsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CatsCollectionViewCell")

        let loadingReusableNib = UINib(nibName: "IndicatorCollectionReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "IndicatorCollectionReusableView")
        
        //  Setup Layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        self.collectionView.collectionViewLayout = layout
        
        //  Add RefreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl) // ???
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        print("MainViewController - refresh() called")
        catArray.removeAll()
        requestAPI(requestPage: 1)
        page = 1
        DispatchQueue.main.async {
            self.isRefreshing = true
            //self.requestAPI()
            
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.isRefreshing = false
        }
    }
    
    // MARK: .GET Cat
    func requestAPI(requestPage: Int) {
        var urlToCall: URLRequestConvertible?
        
        urlToCall = ImageRouter.getCats(limit: String(limit), page: String(requestPage))
        
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
    //MARK: Infinity Scroll 📌 완전 수정 필요
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
//            page += 1
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//
//                print("인피니티\(self.page)")
//                //self.requestAPI(requestPage: self.page + 1)
//            })
//        }
//    }
    
    //  MARK: Infinite Scrolling
    
    ///  Set Footer ( Indicator)
    ///  collectionView의 layout이 CHTCollectionViewWaterfallLayout이기 때문에 아래 CHTCo...layout에서 높이를 정의해줘야 함.
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if self.isLoading {
//            return CGSize.zero
//        } else {
//            return CGSize(width: collectionView.bounds.size.width, height: 55)
//        }
//    }
    
    //  Set the reueable view in the CollectionView Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CELL_IDENTIFIER.INDICATOR_VIEW, for: indexPath) as! IndicatorCollectionReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    //  Start the activityIndicator's animation when the footer appears
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            print("MainViewController - Indicator Start Animation")
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    //  Stop the activityIndicator's animation when the footer disappears
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        print("MainViewController - Indicator Stop Animation")
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //  Request API
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == catArray.count - 1 && !self.isLoading { // indexPath == catArray.count - 1 는 사용자의 스크롤이 마지막 indexPath임을 의미한다.
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                //sleep(3)
                // API Request
                self.page += 1
                //self.requestAPI(requestPage: self.page)
                DispatchQueue.main.async {
                    self.requestAPI(requestPage: self.page)
                    //self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
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
    

    //  Set Indicator LoadingView ( = footer ) height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        if self.isLoading {
            return CGFloat(0)
        } else {
            return CGFloat(50)
        }
    }
 
}

//MARK: - PostFavoriteCatDelegate - API .POST Call
extension MainViewController: PostFavoriteCatDelegate {
    
    /// Favorite Button이 눌렸을때 호출
    /// 선택한 버튼이 위치한 cell의 indexPath를 버튼의 tag로 설정 후
    /// catArray[indexPath.row]의 id를 즐겨찾기로 추가한다.
    func favoriteButtonPressed(indexPath: Int) {
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
