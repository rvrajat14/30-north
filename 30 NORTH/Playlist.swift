//
//  Playlist.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    
    var isCollaborative: Bool?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [ImageSpotify]?
    var name: String?
    var owner: UserSpotify?
    var isPublic: Bool?
    var snapshotId: String?
    var tracks: PlaylistTracks?
    //    var type: SpotifyObjectType?
    var uri: String?
    
    enum CodingKeys: String, CodingKey {
        case isCollaborative = "collaborative"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case images = "images"
        case name = "name"
        case owner = "owner"
        case isPublic = "public"
        case snapshotId = "snapshot_id"
        case tracks = "tracks"
        //        case type = "type"
        case uri = "uri"
    }
}

extension Playlist: Equatable {
    static func ==(lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PlaylistTracks: Codable {
    var href: String?
    var total: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case href = "href"
        case total = "total"
    }
}

enum SpotifyObjectType: String {
    case album
    case artist
    case track
    case playlist
    case user
}
