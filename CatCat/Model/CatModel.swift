//
//  CatModel.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

//  Main
//  .GET
struct Cats: Decodable {
    var id: String
    var url: String
    var width: Int?
    var height: Int?
}


//  Favorite
//  .GET
struct FavoriteCats: Decodable {
    var id: Int
    var user_id: String
    var image_id: String
    var created_at: String
    var image: FavoriteCatImage
    
}

struct FavoriteCatImage: Decodable {
    var id: String
    var url: String
    var width: CGFloat?
    var height: CGFloat?
}
