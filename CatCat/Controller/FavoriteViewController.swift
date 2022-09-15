//
//  FavoriteViewController.swift
//  CatCat
//
//  Created by Ekko on 2022/09/11.
//

import UIKit
import Alamofire

class FavoriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("FavoriteViewController - viewDidLoad()")
        requestAPI()
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
                    print(response)
                }
        }
    }

}


/// 콜렉션뷰에 즐겨찾기한 고양이들 뿌리자.
/// 버튼 탭하면 즐겨찾기 해제 (팝업 메시지 x) ( UserDefaults로 처음 favorite view에 들어왔으면 안내 메시지 )
