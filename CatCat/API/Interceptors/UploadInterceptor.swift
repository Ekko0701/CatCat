//
//  UploadInterceptor.swift
//  CatCat
//
//  Created by Ekko on 2022/09/21.
//

import Foundation
import Alamofire

class UploadInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("UploadInterceptor - adapt() called")
        
        //  Add Header
        var request = urlRequest
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue(API.X_API_KEY, forHTTPHeaderField: "x-api-key")
        
        completion(.success(request)) //값이 수정된 request를 보내준다.
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("UploadInterceptor - retry() called")
    
    }
}
