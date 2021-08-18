//
//  Categories.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import Foundation

struct Categories: Codable {
    let data: [Category]
}

struct Category: Codable {
    let id: Int?
    let name: String?
    let unit: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case unit
        case count
    }
}
