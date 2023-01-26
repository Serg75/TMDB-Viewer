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
    let genre: Genre
    let page: Int

    let methodPath = "/discover/movie"
    
    var extraData: [String : String]? {
        ["sort_by": "popularity.desc", "page": "\(page)", "with_genres": "\(genre.id)"]
    }
    
    init(genre: Genre = Genre(id: 0, name: ""), page: Int = 1) {
        self.genre = genre
        self.page = page
    }
}
