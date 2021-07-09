//
//  User.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import Foundation

class User {
    // Keep track of the albums the user is following
    
    // The relationship persists as long as your application is in memory
    // Can also save the data locally into the file system
    var followingAlbums = [String]()
    var favoritedSongs = [String]()
}
