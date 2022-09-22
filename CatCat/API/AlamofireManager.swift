//
//  AlamofireManager.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

final class AlamofireManager {
    
    static let shared = AlamofireManager()
    
    
    
    //  Interceptor
    //  Add Header, Body, Parameter to Request
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    //  Moniter
    //  print Logger using Moniter
    let monitors = [AlamofireLogger()] as [EventMonitor]
    
    //  Network Session
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
