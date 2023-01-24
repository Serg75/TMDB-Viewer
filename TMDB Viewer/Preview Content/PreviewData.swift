//
//  PreviewData.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-24.
//

import Foundation

struct PreviewData {
    static var Movies: MovieList = {
        let url = Bundle.main.url(forResource: "movies", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(MovieList.self, from: data)
    }()
}
