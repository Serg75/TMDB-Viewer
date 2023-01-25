//
//  MovieViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import Foundation
import SwiftUI

class MovieViewModel: ObservableObject, Identifiable, Hashable {
    private let movie: Movie?
    let uuid = UUID()
    let id: Int
    let title: String
    let imageURL: URL?
    
    init(movie: Movie?) {
        self.movie = movie
        if let movie = movie {
            self.id = movie.id
            self.title = movie.title ?? "No title"
            self.imageURL = ImageResource(namePart: movie.imageURL ?? "", resolution: .w200).url
        } else {
            self.id = 0
            self.title = "No title"
            self.imageURL = nil
        }
    }
    
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
