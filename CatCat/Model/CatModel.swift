//
//  CatModel.swift
//  CatCat
//
//  Created by Ekko on 2022/09/15.
//

import Foundation
import Alamofire

///  Main
///  .GET
///  My
///  .GET
struct Cats: Decodable {
    var id: String
    var url: String
    var width: Int?
    var height: Int?
    var isFavorite: Bool? = false    //  favorite 여부
    var favourite_id: String?       // delete를 위한 id 값
}


///  Favorite
///  .GET
struct FavoriteCats: Decodable {
    var id: Int
    var user_id: String
    var image_id: String
    var created_at: String
    var image: FavoriteCatImage
    var isFavorite: Bool? = true
    
}

struct FavoriteCatImage: Decodable {
    var id: String
    var url: String
    var width: CGFloat?
    var height: CGFloat?
}

/// Favorite
/// .POST
struct PostFavoriteResponse: Decodable {
    var message: String
    var id: Int? 
}


///  My
/// .POST

