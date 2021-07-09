//
//  UserService.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import Foundation

class UserService {
    static let shared = UserService()
    private init(){}
    
    private let currentUser = User()
    
    func favoriteSong(song: Song) {
        if !isFavoritedSong(song: song) {
            currentUser.favoritedSongs.append(song.title)
        }
    }
    
    func unfavoriteSong(song: Song) {
        if let index = currentUser.favoritedSongs.firstIndex(of: song.title) {
            currentUser.favoritedSongs.remove(at: index)
        }
    }
    
    func isFavoritedSong(song: Song) -> Bool {
        return currentUser.favoritedSongs.contains(song.title)
    }
    
    func followAlbum(album: Album) {
        if !isFollowingAlbum(album: album) {
            currentUser.followingAlbums.append(album.name)
            album.followers = album.followers + 1
        }
    }
    
    func unfollowAlbum(album: Album) {
        if let index = currentUser.followingAlbums.firstIndex(of: album.name) {
            currentUser.followingAlbums.remove(at: index)
            album.followers = album.followers - 1
        }
    }
    
    func isFollowingAlbum(album: Album) -> Bool {
        return currentUser.followingAlbums.contains(album.name)
    }
}
