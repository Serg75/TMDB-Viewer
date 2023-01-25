//
//  MovieView.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject private var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(spacing: 16.0) {
            KFImage(viewModel.imageURL)
                .placeholder {
                    SwiftUI.Image("movie-placeholder")
                        .resizable()
                        .scaledToFill()
                }
                .resizable()
                .cancelOnDisappear(true)
                .frame(width: 40.0, height: 40.0)
                .clipped()
            
            Text(viewModel.title)
        }
        .padding(.vertical, 8.0)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(viewModel: MovieViewModel(movie: PreviewData.Movies.movies[0]))
            .previewLayout(.sizeThatFits)
    }
}
