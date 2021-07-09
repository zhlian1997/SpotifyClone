//
//  Song.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/27.
//

import Foundation

class Song: Codable {
    let title: String
    let artist: String
    
    init (title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
}
