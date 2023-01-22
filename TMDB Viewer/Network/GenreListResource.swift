//
//  GenreListResource.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import Foundation

/// Resorce for fetching genre list
struct GenreListResource: APIResource {
    typealias ModelType = GenreList

    var methodPath = "/genre/movie/list"
}
