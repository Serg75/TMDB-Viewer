//
//  MovieViewModel.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import Foundation
import SwiftUI
import UIKit

class MovieViewModel: ObservableObject, Identifiable {
    internal let id: Int?
    private let movie: Movie?
    let title: String
    private let imageURL: URL?
    @Published private(set) var image: UIImage?
    
    init(movie: Movie?) {
        self.id = movie?.id
        self.movie = movie
        self.title = movie?.title ?? "No title"
        self.imageURL = movie?.imageURL
        self.image = nil
    }
}
