//
//  MovieListResource.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-22.
//

import Foundation

/// Resorce for fetching movie list of specific genre
struct MovieListResource: APIResource {
    typealias ModelType = MovieList
    var genre: Genre
    var page: Int

    var methodPath = "/discover/movie"
    
    var extraData: [String : String]? {
        ["sort_by": "popularity.desc", "page": "\(page)", "with_genres": "\(genre.id)"]
    }
}
