//
//  SongCell.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import UIKit

class SongCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func update(song: Song) {
        titleLabel.text = song.title
        artistLabel.text = song.artist
    }
}
