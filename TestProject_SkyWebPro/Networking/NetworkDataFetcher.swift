//
//  NetworkDataFetcher.swift
//  TestProject_SkyWebPro
//
//  Created by Михаил on 17.08.2021.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchCategories(response: @escaping (Categories?) -> Void) {
        networkService.request(urlString: "http://62.109.7.98/api/categories") { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(Categories.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetchProducts(id: Int, response: @escaping (Products?) -> Void) {
        networkService.request(urlString: "http://62.109.7.98/api/product/category/\(id)") { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(Products.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
