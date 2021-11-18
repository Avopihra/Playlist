//
//  SongsModel.swift
//  Playlist
//
//  Created by Viktoriya on 30.10.2021.
//

import Foundation

struct SongsModel: Decodable {
    
    let results: [Song]
    
}

struct Song:  Decodable {
    let trackName: String?
}

