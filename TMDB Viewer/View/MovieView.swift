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
    
    var width: Double
    var height: Double
    
    init(viewModel: MovieViewModel, width: Double = 170, height: Double = 250) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(viewModel.imageURL)
                .placeholder {
                    SwiftUI.Image("movie-placeholder")
                        .resizable()
                        .scaledToFill()
                }
                .resizable()
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height, alignment: .top)
                .clipped()
                .cornerRadius(7)
            
            Text(viewModel.title)
                .font(.headline)
                .lineLimit(2)
                .frame(alignment: .top)
        }
        .frame(width: width)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(viewModel: MovieViewModel(movie: PreviewData.Movies.movies[0]))
            .previewLayout(.sizeThatFits)
    }
}
