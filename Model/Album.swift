//
//  Album.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/27.
//

import Foundation

class Album: Codable {
    let name: String
    var followers: Int
    let artist: String
    let image: String
    let songs: [Song] // one-to-many
    
    init (name: String, followers: Int, artist: String, image: String, songs: [Song]) {
        self.name = name
        self.followers = followers
        self.artist = artist
        self.image = image
        self.songs = songs
    }
}
