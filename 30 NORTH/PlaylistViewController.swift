//
//  PlaylistViewController.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
}
/*
    @IBOutlet weak var spotifyLogoutItemButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var spotifyObject: SpotifyObject<PlaylistTrack>?
    
    fileprivate var isFetching = false
    fileprivate var spotifyId : String = SpotifyService.shared.SPOTIFY_ID
    
    var limit = 100
    var offset = 0
    
    var playlist: Playlist? {
        didSet {
            guard let playlist = playlist else {
                return
            }
            if let name = playlist.name {
                navigationItem.title = "30 North Music"//name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        // Do any additional setup after loading the view.
        self.configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    //MARK:- USER DEFINED METHODS
    private func configUI() {
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
        self.getPlaylist()
    }
    func navigateToSpotifyLogin() {
        
        if let playlistViewController = mainStoryboard.instantiateViewController(withIdentifier: "MusicMainViewController") as? MusicMainViewController, let revealController_ = globalRevealViewController  {
            let navigationController = UINavigationController(rootViewController: playlistViewController)
            revealController_.pushFrontViewController(navigationController, animated: true)
        }
    }

    private func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.northMusics
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]        
    }
    
    @IBAction func onSpotifyLogout(_ sender: Any) {
    
        SpotifyService.shared.logout()
        navigateToSpotifyLogin()
    }
    
    private func getPlaylist() {
        
        _ = EZLoadingActivity.show("Getting Playlist...", disableUI: true)

        API.fetchPlaylist(playlistId: spotifyId) { (playListObject, error) in
            
            _ = EZLoadingActivity.hide()

            if let error = error {
                _ = SweetAlert().showAlert(language.northMusics, subTitle: error.localizedDescription, style: AlertStyle.customImag(imageFile: "Logo"))
            }
            
            DispatchQueue.main.async {
                if let playListObj = playListObject{
                    self.playlist = playListObj
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.fetchTracks()
                    }
                }
            }
        }
    }
    
    private func fetchTracks() {

        isFetching = true
       //print("Fetching tracks offset(\(offset))")
        
        _ = EZLoadingActivity.show("Getting Tracks...", disableUI: true)
        
        API.fetchPlaylistsTracks(playlistId: spotifyId, limit: limit, offset: offset) { (spotifyObject, error) in
            
            _ = EZLoadingActivity.hide()

            self.isFetching = false
            self.offset = self.offset + self.limit
            
            DispatchQueue.main.async {
                if let error = error {
                    _ = SweetAlert().showAlert(language.northMusics, subTitle: error.localizedDescription, style: AlertStyle.customImag(imageFile: "Logo"))
                }
                
                if let spotifyObject = spotifyObject, let items = spotifyObject.items{
                    if self.spotifyObject == nil {
                        self.spotifyObject = spotifyObject
                    } else {
                        self.spotifyObject?.items?.append(contentsOf: items)
                        self.spotifyObject?.next = spotifyObject.next
                        self.spotifyObject?.total = spotifyObject.total
                    }
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func onMusicPlay(_ sender : UIButton) {
        if let playMusicViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlayMusicViewController") as? PlayMusicViewController {
            playMusicViewController.track = spotifyObject?.items?[sender.tag].track
            playMusicViewController.index = sender.tag
            playMusicViewController.playlistURI = playlist?.uri ?? ""
            self.present(playMusicViewController, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionViewDelegate
extension PlaylistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /**** Did Select ***/
    }
}

// MARK: UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotifyObject?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as? PlaylistCollectionViewCell {
            
            let track = spotifyObject?.items?[indexPath.item].track
            cell.track = track
            cell.position = indexPath.item
            cell.playButton.tag = indexPath.item
            cell.playButton.addTarget(self, action: #selector(onMusicPlay), for: .touchUpInside)
            
            if let totalItems = spotifyObject?.items?.count, indexPath.item == totalItems - 1, spotifyObject?.next != nil {
                if !isFetching {
                    fetchTracks()
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaylistHeaderView", for: indexPath) as? PlaylistHeaderView {
                headerView.playlist = playlist
                return headerView
            }
        default: break
        }
        return UICollectionReusableView()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - (8 * 2), height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}
 
 */


