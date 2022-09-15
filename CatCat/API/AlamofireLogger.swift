//
//  AlamofireLogger.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

final class AlamofireLogger: EventMonitor {
    let queue = DispatchQueue(label: "AlamofireLogger")
    
    func requestDidResume(_ request: Request) {
        print("AlamofireLogger - requestDidResume()")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("AlamofireLogger - request.didParseResponse()")
        debugPrint(response)
    }
}
