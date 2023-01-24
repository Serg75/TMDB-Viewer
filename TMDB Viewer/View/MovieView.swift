//
//  MovieView.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-23.
//

import SwiftUI

struct MovieView: View {
    @StateObject private var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var image: Image {
        guard let posterImage = viewModel.image else {
            return Image(systemName: "questionmark.circle")
        }
        return Image(uiImage: posterImage)
    }

    var body: some View {
        HStack(spacing: 16.0) {
            image
                .resizable()
                .frame(width: 36.0, height: 36.0)
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
