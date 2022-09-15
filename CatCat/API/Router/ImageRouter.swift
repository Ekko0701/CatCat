//
//  ImageRouter.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

/// .GET
/// images/search
/// images/(yourupload)
///
/// .POST
/// images/upload
///
/// .DEL
/// images/:image_id

enum ImageRouter: URLRequestConvertible {
    
    //  Cases
    case getCats(limit: String, page: String)
    case getUploadedCats(limit: String, page: String)
    
    //  Set BaseURL
    //  https://api.thecatapi.com/v1/images
    var baseURL: URL {
        return URL(string: API.BASE_URL + "v1/images/")!
    }
    
    //  Setup HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getCats:
            return .get
        case .getUploadedCats:
            return .get
        }
    }
    
    //  Setup End Point
    var endPoint: String {
        switch self {
        case .getCats:
            return "search/"
        case .getUploadedCats:
            return ""
        }
    }
    
    //  Setup Parameters
    var parameters: [String: String] {
        switch self {
        case let .getCats(limit, page):
            return [
                "limit" : limit,
                "page" : page,
            ]
        case let .getUploadedCats(limit, page):
            return [
                "limit" : limit,
                "page" : page,
            ]
        }
    }
    
    //  Setup Request
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case .getCats:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case .getUploadedCats:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}
