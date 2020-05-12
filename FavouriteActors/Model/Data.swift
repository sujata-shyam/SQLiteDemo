//
//  Data.swift
//  FavouriteActors
//
//  Created by Sujata on 12/05/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

//import Foundation


struct completeData : Codable {
    let page : Int?
    let per_page : Int?
    let total : Int?
    let total_pages : Int?
    let data : [actorData]?
    let ad : Ad?
}

struct actorData : Codable {
    let id : Int?
    let email : String?
    let first_name : String?
    let last_name : String?
    let avatar : String?
    var isFav: Bool? 
}

struct Ad : Codable {
    let company : String?
    let url : String?
    let text : String?
}


