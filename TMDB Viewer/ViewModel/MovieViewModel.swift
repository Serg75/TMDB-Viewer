//
//  MovieViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import Foundation
import SwiftUI
import UIKit

class MovieViewModel: ObservableObject, Identifiable, Hashable {
    let uuid = UUID()
    let id: Int
    private let movie: Movie?
    let title: String
    private let imageURL: URL?
    @Published private(set) var image: UIImage?
    
    init(movie: Movie?) {
        self.id = movie?.id ?? 0
        self.movie = movie
        self.title = movie?.title ?? "No title"
        self.imageURL = movie?.imageURL
        self.image = nil
    }
    
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
