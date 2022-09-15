//
//  BaseInterceptor.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        
        //  Add Header
        var request = urlRequest
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(API.X_API_KEY, forHTTPHeaderField: "x-api-key")
        
        //  Add Common Parameter
        var commonParameters = [String: String]()
        
        do {
            request = try URLEncodedFormParameterEncoder().encode(commonParameters, into: request)
        } catch {
            print(error.localizedDescription)
        }
        
        completion(.success(request)) //값이 수정된 request를 보내준다.
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
    
    }
}
