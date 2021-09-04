//
//  MusicMainViewController.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import SafariServices

class MusicMainViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    fileprivate var firstLoad : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        //Disabling spotify due to Apple uiwebview use
        // Do any additional setup after loading the view.
        //NotificationCenter.default.addObserver(self, selector: #selector(sessionUpdatedNotification), name: NSNotification.Name("sessionUpdated"), object: nil)
        //firstLoad = true
        //self.configUI()
 
    }
    
    /*
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    //MARK:- USER DEFINED METHODS
    private func configUI() {
        
        globalRevealViewController = self.revealViewController()
        self.view.isHidden = false

        getUserIsAlreayLoggedIn()
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
    }
    
    private func getUserIsAlreayLoggedIn() {
        
        let auth = SPTAuth.defaultInstance()
//        Check if we have a token at all
        if auth.session == nil {
            return
        }
        
        // Check if it's still valid
        if let session = auth.session, session.isValid() && self.firstLoad {
             self.firstLoad = false
            self.view.isHidden = true
            navigateToPlayList()
        }
        
        // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
        if auth.hasTokenRefreshService {
            self.view.isHidden = true
            self.renewTokenAndShowList()
            return
        }
    } 
    
    func renewTokenAndShowList() {
        
        _ = EZLoadingActivity.show("Renewing...", disableUI: false)
        
        let auth = SPTAuth.defaultInstance()
        if let session = auth.session {
            auth.renewSession(session) { (error, session) in
                
                _ = EZLoadingActivity.hide()
                
                auth.session = session
                SpotifyService.shared.saveRefreshTokenResponse(refreshTokenResponse: session)
                
                if error != nil {
                    self.view.isHidden = false
                    return
                }
                
                self.firstLoad = false
                navigateToPlayList()
            }
        }
    }
    
    @objc func sessionUpdatedNotification() {
        
        let auth = SPTAuth.defaultInstance()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        if let session = auth.session, session.isValid() {
            firstLoad = false
            navigateToPlayList()
        }
    }
    
    private func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.northMusics
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK:- IBACTION METHODS
    @IBAction func onLoginWithSpotify(_ sender : UIButton) {
        
        let auth = SPTAuth.defaultInstance()
        
        if SPTAuth.supportsApplicationAuthentication() {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(auth.spotifyAppAuthenticationURL(), options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(auth.spotifyAppAuthenticationURL())
            }
        }else {
            let safariVC = SFSafariViewController(url: SPTAuth.defaultInstance().spotifyWebAuthenticationURL())
            self.definesPresentationContext = true
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
 */

}
