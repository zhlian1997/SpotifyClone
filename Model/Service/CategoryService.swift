//
//  CategoryService.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/27.
//

import Foundation


// Singleton
// Manage a collection of categories
class CategoryService {
    static let shared = CategoryService()
    
    let categories: [Category]
    
    // Decode our JSON file and populate that into our categories array
    // Swift's Codable API (confrom to Codable protocal)
    private init() {
        
        // get URL from the Bundle singleton
        let categoriesUrl = Bundle.main.url(forResource: "categories", withExtension: "json")!
        let data = try! Data(contentsOf: categoriesUrl)
        let decoder = JSONDecoder()
        categories = try! decoder.decode([Category].self, from: data)
        // We get our fully populated categories array
    }
}

