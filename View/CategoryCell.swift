//
//  CategoryCell.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/6/28.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func update (category: Category, index: Int) {
        titleLabel.text = category.title
        subTitleLabel.text = category.subtitle
        
        // so that every collectionView will know what category they belongs to
        collectionView.tag = index
        // trigger the collection view to refresh its data
        collectionView.reloadData()
    }
}
