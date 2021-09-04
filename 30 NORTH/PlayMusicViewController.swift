//
//  PlayMusicViewController.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayMusicViewController: UIViewController {
}
    /*
    
    @IBOutlet weak var trackTitle : UILabel!
    @IBOutlet weak var artistTitle : UILabel!
    @IBOutlet weak var coverView : UIImageView!
    @IBOutlet weak var coverView2 : UIImageView!
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    @IBOutlet weak var progressSlider : UISlider!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var prevButton : UIButton!
    @IBOutlet weak var playButton : UIButton!
    @IBOutlet weak var playbackSourceTitle : UILabel!
    
    public var track : Track?
    public var index : Int = 0
    var playlistURI : String = ""

    fileprivate var isChangingProgress : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
           //print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
           //print("Session is Active")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
            
        } catch {
           //print(error)
        }
        stopSotifyPlayer()
        // Do any additional setup after loading the view.
        self.trackTitle.text = ""
        self.artistTitle.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       

        self.handleNewSession()
    }
    private func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "30 North"]
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            if let player = spotifyPlayer {
                self!.playButton.isSelected = player.playbackState.isPlaying
            }
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self!.stopSotifyPlayer()
            return .success
        }
    }

    //MARK:- USER DEFINED METHODS
    private func updateUI() {
        
        self.trackTitle.text = ""
        self.artistTitle.text = ""
        
        let auth = SPTAuth.defaultInstance()
        
        if spotifyPlayer == nil, spotifyPlayer?.metadata == nil, spotifyPlayer?.metadata.currentTrack == nil
        {
            self.coverView.image = nil
            self.coverView2.image = UIImage(named: "music")
            return
        }
        
        //_ = EZLoadingActivity.show("Getting Image...", disableUI: false)
        
        self.coverView.image = nil
        self.coverView2.image = UIImage(named: "music")
        self.progressSlider.value = 0
        self.nextButton.isEnabled = spotifyPlayer?.metadata.nextTrack != nil
        self.prevButton.isEnabled = spotifyPlayer?.metadata.prevTrack != nil
        self.prevButton.alpha = spotifyPlayer?.metadata.prevTrack != nil ? 1.0 : 0.5
        self.nextButton.alpha = spotifyPlayer?.metadata.nextTrack != nil ? 1.0 : 0.5
        self.trackTitle.text = spotifyPlayer?.metadata.currentTrack?.name
        self.artistTitle.text = spotifyPlayer?.metadata.currentTrack?.artistName
        self.playbackSourceTitle.text = spotifyPlayer?.metadata.currentTrack?.playbackSourceName
        
        if let uri = spotifyPlayer?.metadata.currentTrack?.uri, uri != "", let accesstoken = auth.session?.accessToken, let url = URL(string: uri){
            SPTTrack.track(withURI: url, accessToken: accesstoken, market: nil) { (error, playerTrack) in
                
                DispatchQueue.main.async {
                    guard let track = playerTrack as? SPTTrack else {
                          // _ = EZLoadingActivity.hide()
                        return
                    }
                    
                    let imageURL = track.album.largestCover.imageURL
                    
                    self.coverView.kf.setImage(with: imageURL) { result in
                        switch result {
                        case .success(let value):
                            self.coverView2.image = value.image.blurred(radius: 10)
                          //_ = EZLoadingActivity.hide()
                        case .failure(let error):
                           print(error) // The error happens
                             // _ = EZLoadingActivity.hide()
                        }
                    }
                }
            }

        }
        
  
    }
        
    private func handleNewSession() {
        
        let auth = SPTAuth.defaultInstance()
        
        if spotifyPlayer == nil {
            spotifyPlayer = SPTAudioStreamingController.sharedInstance()
            
            do {
                try? spotifyPlayer?.start(withClientId: auth.clientID ?? "")
                spotifyPlayer?.delegate = self
                spotifyPlayer?.playbackDelegate = self
                spotifyPlayer?.login(withAccessToken: auth.session?.accessToken ?? "")
            }
            catch {
               //print(error)
                spotifyPlayer = nil
                _ = SweetAlert().showAlert(language.northMusics, subTitle: error.localizedDescription, style: AlertStyle.customImag(imageFile: "Logo"))
                self.closeSession()
            }
        }
    }
    
    func stopSotifyPlayer(){
        if let player = spotifyPlayer {
            do {
                try? player.stop()
                spotifyPlayer = nil
            } catch {
               //print(error)
            }
        }
    }
    
    private func closeSession() {
        
        if let player = spotifyPlayer {
            do {
                try? player.stop()
            } catch {
               //print(error)
                _ = SweetAlert().showAlert(language.northMusics, subTitle: error.localizedDescription, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        }
            
        self.dismiss(animated: true, completion: nil)
    }
    
    private func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
           //print(error)
        }
    }
    
    private func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
           //print(error)
        }
    }

    //MARK:- IBACTION METHODS
    @IBAction func onClose(_ sender : UIButton) {
        
//        if let player = spotifyPlayer {
//            player.logout()
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previous(_ sender : UIButton) {
        spotifyPlayer?.skipPrevious({ (error) in
           //print(error?.localizedDescription ?? "")
        })
    }
    
    @IBAction func playPause(_ sender : UIButton) {
        
        if let player = spotifyPlayer {
            playButton.isSelected = !player.playbackState.isPlaying
            player.setIsPlaying(!player.playbackState.isPlaying, callback: { (error) in
               //print(error?.localizedDescription ?? "")
            })
        }
    }
    
    @IBAction func next(_ sender : UIButton) {
        spotifyPlayer?.skipNext({ (error) in
           //print(error?.localizedDescription ?? "")
        })
    }
    
    @IBAction func seekValueChanged(_ sender : Any) {
        self.isChangingProgress = false
        if let player = spotifyPlayer {
           //print(self.progressSlider.value)
            let dest = Double(player.metadata.currentTrack?.duration ?? 0) * Double(self.progressSlider.value)
            let value = round(dest)
            player.seek(to: value) { (error) in
               //print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func proggressTouchDown(_ sender : Any) {
        self.isChangingProgress = true
    }
}

//MARK:- EXTENSION METHODS
extension PlayMusicViewController : SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceiveMessage message: String) {
       //print("test")
        _ = SweetAlert().showAlert(language.northMusics, subTitle: message, style: AlertStyle.customImag(imageFile: "Logo"))
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePlaybackStatus isPlaying: Bool) {
        
        if isPlaying {
            self.activateAudioSession()
        }else {
            self.deactivateAudioSession()
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceive event: SpPlaybackEvent) {
        
       // _ = EZLoadingActivity.hide()
       //print("didReceivePlaybackEvent: %zd %@", event)
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController) {
        self.closeSession()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceiveError error: Error) {
        _ = SweetAlert().showAlert(language.northMusics, subTitle: error.localizedDescription, style: AlertStyle.customImag(imageFile: "Logo"))
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePosition position: TimeInterval) {
        
        if (self.isChangingProgress) {
            return
        }
        
        if let playerDuration = spotifyPlayer?.metadata.currentTrack?.duration {
            self.progressSlider.value = Float(position/playerDuration)
        }
        
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStartPlayingTrack trackUri: String) {
        
       //print("Starting %@", trackUri);
        if let player = spotifyPlayer {
            playButton.isSelected = player.playbackState.isPlaying
        }
        
       //print("Source %@", spotifyPlayer?.metadata.currentTrack?.playbackSourceUri ?? "");
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStopPlayingTrack trackUri: String) {
       //print("Finishing: %@", trackUri)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController) {
        
        self.updateUI()
        
        spotifyPlayer?.playSpotifyURI(playlistURI, startingWith: UInt(index), startingWithPosition: 0, callback: { (error) in
            if error != nil{
                return
            }
        })
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChange metadata: SPTPlaybackMetadata) {
        self.updateUI()
    }
}
 
 */

