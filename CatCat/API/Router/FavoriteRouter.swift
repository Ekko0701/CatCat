//
//  FavoriteRouter.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

/// .GET
/// /favorites
///
/// .POST
/// /favorites
///
/// .DEL
/// /favorites/:favorite_id

import Foundation
import Alamofire

enum FavoriteRouter: URLRequestConvertible {
    
    //  Cases
    case getFavorites
    case postFavorites
    
    //  Set BaseURL
    var baseURL: URL {
        return URL(string: API.BASE_URL + "v1/favourites")!
    }
    
    //  Setup HTTP Method
    var method : HTTPMethod {
        switch self {
        case .getFavorites:
            return .get
        case .postFavorites:
            return .post
        }
    }
    
    //  Setup End Point
    var endPoint: String {
        switch self {
        case .getFavorites:
            return ""
        case .postFavorites:
            return ""
        }
    }
        
    //  Favorite Router has no Parameters only 'Headers'
    
    //  SetUp Request
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        return request
    }
}
