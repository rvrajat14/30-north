//
//  PlaylistHeaderView.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class PlaylistHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else {
                return
            }
            if let img = playlist.images?[0], let imgUrlString = img.url, let url = URL(string: imgUrlString) {
                imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(.fade(0.2))])
            } else {
                imageView.image = #imageLiteral(resourceName: "placeholder")
            }
            if let playlistName = playlist.name {
                titleLabel.text = playlistName
            }
        }
    }
}
