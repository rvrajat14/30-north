//
//  PlaylistTrack.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

struct PlaylistTrack: Codable {
    var track: Track?
    
    enum CodingKeys: String, CodingKey
    {
        case track = "track"
    }
}

struct Track: Codable {
    
    var album: Album?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var discNumber: Int?
    var durationMS: Int?
    var isExplicit: Bool?
    var externalIds: ExternalIds?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var name: String?
    var popularity: Int?
    var previewUrl: String?
    var trackNumber: Int?
    var uri: String?
    
    enum CodingKeys: String, CodingKey
    {
        case album = "album"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case isExplicit = "explicit"
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case name = "name"
        case popularity = "popularity"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case uri = "uri"
    }
}


extension Track: Equatable {
    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Album: Codable {
    
    var albumType: String?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [ImageSpotify]?
    var name: String?
    var uri: String?
    
    enum CodingKeys: String, CodingKey
    {
        case albumType = "album_type"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case uri = "uri"
    }
}


struct Artist: Codable {
    
    var externalUrls: ExternalUrls?
    var followers: Followers?
    var genres: [String]?
    var href: String?
    var id: String?
    var images: [ImageSpotify]?
    var name: String?
    var popularity: Int?
    var uri: String?
    
    enum CodingKeys: String, CodingKey
    {
        case externalUrls = "external_urls"
        case followers = "followers"
        case genres = "genres"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case popularity = "popularity"
        case uri = "uri"

    }
}

extension Artist: Equatable {
    static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }
}


struct ExternalIds: Codable {
    var isrc: String?
    
    enum CodingKeys: String, CodingKey
    {
        case isrc = "isrc"
    }
}
