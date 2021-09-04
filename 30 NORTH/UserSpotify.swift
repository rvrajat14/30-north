//
//  UserSpotify.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

let NMUserDefaults = UserDefaults.standard

struct UserSpotify: Codable {
    
    var country: String?
    var displayName: String?
    var email: String?
    var externalUrls: ExternalUrls?
    var followers: Followers?
    var href: String?
    var id: String?
    var images: [ImageSpotify]?
    var product: String?
    var type: String?
    var uri: String?
    
    static var currentSpotifyUser = UserSpotify()
    private init () {}
    
    func saveToDefaults () {
        NMUserDefaults.set(id, forKey: "currentUserId")
        NMUserDefaults.synchronize()
    }
    
   func setCurrentSpotifyUserDetails() {
    if let encoded = try? JSONEncoder().encode(UserSpotify.currentSpotifyUser) {
            NMUserDefaults.set(encoded, forKey: "spotifyUserDetails")
            NMUserDefaults.synchronize()
        }else {
            NMUserDefaults.set(nil, forKey: "spotifyUserDetails")
            NMUserDefaults.synchronize()
        }
    }
    
    static func getCurrentSpotifyUserDetails() -> UserSpotify? {
        if let userData = NMUserDefaults.data(forKey: "spotifyUserDetails"),
            let user = try? JSONDecoder().decode(UserSpotify.self, from: userData) {
            return user
        }
        
        return nil
    }

    
    enum CodingKeys: String, CodingKey
    {
        case country = "country"
        case displayName = "display_name"
        case email = "email"
        case externalUrls = "external_urls"
        case followers = "followers"
        case href = "href"
        case id = "id"
        case images = "images"
        case product = "product"
        case type = "type"
        case uri = "uri"
    }
}

struct ExternalUrls: Codable {
    var spotify: String?
    
    enum CodingKeys: String, CodingKey
    {
        case spotify = "spotify"
    }
}

struct Followers: Codable {
    var href: String?
    var total: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case href = "href"
        case total = "total"
    }
}

struct ImageSpotify: Codable {
    
    var height: Int?
    var url: String?
    var width: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case height = "height"
        case url = "url"
        case width = "width"
    }
}

