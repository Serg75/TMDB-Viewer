//
//  ImageResource.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-25.
//

import Foundation

fileprivate let IMAGE_TMDB_URL = "https://image.tmdb.org"

enum Resolution {
    case w200, w300, w400, w500
}

/// Resorce for fetching images
struct ImageResource: APIResource {
    typealias ModelType = MovieList
    let namePart: String
    let resolution: Resolution

    let methodPath = "/t/p/"
    
    var url: URL {
        return URL(string: "\(IMAGE_TMDB_URL)\(methodPath)\(resolution)\(namePart)")!
    }
}
