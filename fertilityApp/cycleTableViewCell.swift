//
//  cycleTableViewCell.swift
//  fertilityApp
//
//  Created by Blake Robinson on 9/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class cycleTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCollectionViewDataSourceDelegate
        (_ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource, forRow row: Int) {
        
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
//    func prepareCollectionView(_ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource, forRow row: Int) {
//        //Or func prepareCollectionView(_ delegateAndDataSource: UICollectionViewDelegate & UICollectionViewDataSource, forRow row: Int) {
//        collectionView.delegate = delegate
//        collectionView.dataSource = dataSource
//        collectionView.tag = row
//        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
//        collectionView.reloadData()
//    }

}
