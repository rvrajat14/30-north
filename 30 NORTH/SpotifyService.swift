//
//  SpotifyAPI.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireMapper

class SpotifyService: NSObject {
    
    /*
    
    let CLIENT_ID = "ac97c41426bd4a1a87bc5e76d864bdf7"
    let CLIENT_SECRET = "652992106b8a4eff8b0ea7276e81f013" 
    let REDIRECT_URI = "northmusic://failure"
    let SESSIONUSERDEFAULTSKEY = "SpotifySession"
    let SPOTIFY_ID = "21UFdFUi4gmgwnU2q071h9"
    
    var AUTHORIZATION_CODE: String? {
        return UserDefaults.standard.string(forKey: AUTHORIZATION_CODE_KEY)
    }
    var ACCESS_TOKEN: String? {
        return UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY)
    }
    var EXPIRES_IN: String? {
        return UserDefaults.standard.string(forKey: EXPIRES_IN_KEY)
    }
    var REFRESH_TOKEN: String? {
        return UserDefaults.standard.string(forKey: REFRESH_TOKEN_KEY)
    }
    var TOKEN_TYPE: String? {
        return UserDefaults.standard.string(forKey: TOKEN_TYPE_KEY)
    }
    
    private let AUTHORIZATION_CODE_KEY = "AUTHORIZATION_CODE_KEY"
    private let ACCESS_TOKEN_KEY = "ACCESS_TOKEN_KEY"
    private let EXPIRES_IN_KEY = "EXPIRES_IN_KEY"
    private let REFRESH_TOKEN_KEY = "REFRESH_TOKEN_KEY"
    private let TOKEN_TYPE_KEY = "TOKEN_TYPE_KEY"
    
    private let playlistTrackURL = "https://api.spotify.com/v1/playlists/%@/tracks"
    private let playlistURL = "https://api.spotify.com/v1/playlists/%@"
    
    var isLoggedIn: Bool {
        return AUTHORIZATION_CODE != nil
    }
    
    private let scopes = ["playlist-read-private", "playlist-read-collaborative", "playlist-modify-public", "playlist-modify-private"]
    
    private var encodedScopes: String {
        return scopes.joined(separator: "%20")
    }
    
    static let shared = SpotifyService()
    private override init () {}
    
    func logout () {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: AUTHORIZATION_CODE_KEY)
        defaults.removeObject(forKey: ACCESS_TOKEN_KEY)
        defaults.removeObject(forKey: EXPIRES_IN_KEY)
        defaults.removeObject(forKey: REFRESH_TOKEN_KEY)
        defaults.removeObject(forKey: TOKEN_TYPE_KEY)
        defaults.synchronize()
        //  UIApplication.topViewController()?.present(LoginViewController(), animated: true, completion: nil)
    }
    
    func fetchPlaylistsTracks(playlistId: String, limit: Int = 20, offset: Int = 0, completion: @escaping (SpotifyObject<PlaylistTrack>?, Error?) -> Void) {
        let parameters: Parameters = [
            "offset": offset,
            "limit": limit,
            "fields": "href,next, items.track,limit,offset,previous,total",
        ]
        
        var headers: HTTPHeaders = [:]
        if let accessToken = ACCESS_TOKEN {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        let playlistTrackURLs = String(format: playlistTrackURL, playlistId)
        
        Alamofire.request(playlistTrackURLs, method: .get, parameters: parameters, headers : headers)
            .responseObject{ (response: DataResponse<SpotifyObject<PlaylistTrack>>) in
                switch response.result {
                case .success(let trackObject):
                    completion(trackObject, nil)
                    break
                case .failure(let error):
                    completion(nil, error)
                    break
                }
        }
    }
    
    func fetchPlaylists (playlistId: String, completion: @escaping (Playlist?, Error?) -> Void) {
        let parameters: Parameters = [:]
        
        var headers: HTTPHeaders = [:]
        if let accessToken = ACCESS_TOKEN {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
       //print(headers)
        
        let playListURL = String(format: playlistURL, playlistId)
        
        Alamofire.request(playListURL, method: .get, parameters: parameters, headers : headers)
            .responseObject { (response: DataResponse<Playlist>) in
                switch response.result {
                case .success(let spotifyObject):
                    completion(spotifyObject, nil)
                    break
                case .failure(let error):
                    completion(nil, error)
                    break
                }
        }
    }
    
    private func saveAuthorizationCode (code: String) {
        UserDefaults.standard.set(code, forKey: AUTHORIZATION_CODE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    public func saveRefreshTokenResponse (refreshTokenResponse: SPTSession?) {
        let defaults = UserDefaults.standard
        guard let refreshTokenResponse = refreshTokenResponse else {
            return
        }
        
        defaults.set(refreshTokenResponse.accessToken, forKey: ACCESS_TOKEN_KEY)
        defaults.set(refreshTokenResponse.expirationDate, forKey: EXPIRES_IN_KEY)
        defaults.set(refreshTokenResponse.tokenType, forKey: TOKEN_TYPE_KEY)
        
        if let refreshToken = refreshTokenResponse.encryptedRefreshToken {
            defaults.set(refreshToken, forKey: REFRESH_TOKEN_KEY)
        }
    
        defaults.synchronize()
    }
 
 */
}

