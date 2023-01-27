//
//  GenreListView.swift
//  TMDB Viewer
//
//  Created by Sergey Slobodenyuk on 2023-01-19.
//

import SwiftUI

struct GenreListView: View {
    @StateObject private var viewModel = GenreListViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.genres) { genre in
                    NavigationLink(destination: MovieListView(genre: genre)) {
                        VStack {
                            Text(genre.name ?? "Unknown")
                        }
                    }
                }
                .navigationTitle("Tmdb")
                .onAppear {
                    viewModel.fetchGenres()
                }
                
                WelcomeView()
                    .padding(.bottom, 50)
            }
            
            if viewModel.genres.count == 0 {
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Loading...")
                }
            }
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to TMDB Viewer!")
                .font(.largeTitle)

            Text("Here you can find almost any movie (most popular on the top).")
                .foregroundColor(.secondary)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GenreListView()
    }
}
