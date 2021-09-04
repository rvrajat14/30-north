//
//  PlaylistCollectionViewCell.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    var track: Track? {
        didSet {
            guard let track = track else {
                return
            }
            if let artistName = track.name {
                titleLabel.text = artistName
            }
            if let artists = track.artists {
                let names = artists.map { $0.name ?? "Uknown Artist" }.joined(separator: ", ")
                subTitleLabel.text = names
                if let albumName = track.album?.name {
                    subTitleLabel.text?.append(" ・ \(albumName)")
                }
            }
        }
    }
    
    var position: Int?
}
