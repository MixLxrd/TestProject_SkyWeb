//
//  Product.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import Foundation

struct Products: Decodable {
    var data: [Product]
}

struct Product: Decodable {
    let id: Int?
    let name: String?
    let ccal: Int?
    let date: String?
    let category_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ccal
        case date
        case category_id
    }
}
