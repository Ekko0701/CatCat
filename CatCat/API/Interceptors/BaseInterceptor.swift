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
        
        //  request.url = 로 분기 주기.
        //print("인터셉터: \(request.url)")
        let requestURL = request.url
        switch (requestURL){
        case URL(string: "https://api.thecatapi.com/v1/images/upload")!:
            request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        default:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.addValue(API.X_API_KEY, forHTTPHeaderField: "x-api-key")
        
        //  Add Common Parameter
        //  다음 코드를 사용하면 다른 api 호출할때 commonParameter만 들어가버린다.
//        var commonParameters = [String: String]()
//        
//        do {
//            request = try URLEncodedFormParameterEncoder().encode(commonParameters, into: request)
//        } catch {
//            print(error.localizedDescription)
//        }
        
        completion(.success(request)) //값이 수정된 request를 보내준다.
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
    }
}
