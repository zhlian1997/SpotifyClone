//
//  Category.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/27.
//

import Foundation

class Category: Codable {
    let title: String  // property
    let subtitle: String
    let albums: [Album]
    
    init (title: String, subtitle: String, albums: [Album]) {
        self.title = title
        self.subtitle = subtitle
        self.albums = albums
    }
}
