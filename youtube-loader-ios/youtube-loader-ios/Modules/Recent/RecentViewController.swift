//
//  RecentViewController.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright (c) 2020 Virych. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

final class RecentViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    

    // MARK: - Public properties -

    var presenter: RecentPresenterInterface!

    // MARK: - Lifecycle -

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
}

// MARK: - Extensions -

extension RecentViewController: RecentViewInterface {
}


extension RecentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        presenter.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = presenter.video(for: indexPath.row)
        cell.imageView.sd_setImage(with: video.thumbnail.url, completed: nil)
        cell.titleLabel.text = video.name
        
        return cell
    }
}


extension RecentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (view.bounds.width - 50) / 2
        
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        navigationController?.pushWireframe(DetailWireframe(video: presenter.video(for: indexPath.row)))
    }
}
