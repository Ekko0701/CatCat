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
    case postFavorites(id: String)
    
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
        
    //  Favorite Router has no Parameters only 'Headers' & Optional 'Body'
    
    //  Setup Body ( exact JSON Encoding)
//    var body: Data? {
//        switch self {
//        case .getFavorites:
//            return nil
//        case let .postFavorites(id):
//            let param = ImageInfo(image_id: id) // 1. 이미지의 Id를 받아와서 ImageInfo Codable 구조체 생성
//            return param.toData //  2. post 할때는 body로 들어가야 하니 toData( encodable extension)으로 Json data 형식으로 변경한다.
//        }
//    }
    
    var parameters: [String: String] {
        switch self {
        case .getFavorites:
            return [:]
        case let .postFavorites(id):
            return ["image_id" : id]
        }
    }
    
    //  SetUp Request
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        //  http body
        switch self {
        case .getFavorites:
            request.httpBody = nil
        case .postFavorites:
            print("바디 - \(parameters)")
            do {
                //request.httpBody = try JSONEncoder().encode(parameters)
                request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
            } catch {
                // Handle Error
            }
            
            //request = try JSONParameterEncoder().encode(parameters, into: request)
            //return request
        }
        
        return request
    }
}
