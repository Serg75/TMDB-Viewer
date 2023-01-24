//
//  Movie.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import Foundation
import UIKit

struct MovieList: Decodable {
    let movies: [Movie]
    let page: Int
    let pageCount: Int
    let movieCount: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case pageCount = "total_pages"
        case movieCount = "total_results"
    }
}

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String?
    let imageURL: URL?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case imageURL = "backdrop_path"
    }
}
