//
//  AlbumCell.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/28.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func update (album: Album) {
        thumbnailImageView.image = UIImage(named: album.image)
        titleLabel.text = album.name
        artistLabel.text = album.artist
    }
}
