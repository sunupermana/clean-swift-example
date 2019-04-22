//
//  ShowListMovieInteractor.swift
//  Clean Swift
//
//  Created by Fabianus Hendy Evan on 05/04/19.
//  Copyright (c) 2019 Fabianus Hendy Evan. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: Boundary protocols
protocol ListMovieInteractorInput {
    func getListMovie()
    func getNowPlayingMovie()
    func getUpcomingMovie()
    func showDetail(movie: MovieModel.Movie2)
}

protocol ListMovieInteractorOutput {
    func presentNowPlayingMovie(response: MovieModel.ViewModel)
    func presentUpcomingMovie(response: MovieModel.ViewModel)
    func presentDetailMovie(response: MovieModel.ViewModel)
}

protocol ListMovieDataStore
{
    //var name: String { get set }
    var detailMovie: MovieModel.Movie2? { get set }
}

class ListMovieInteractor: ListMovieInteractorInput, ListMovieDataStore
{
    var detailMovie: MovieModel.Movie2?
    
    var output: ListMovieInteractorOutput!
    var worker: ListMovieWorker?
    
    // MARK: Do something
    
    func getListMovie() {
        let params = MovieModel.Request.init(apiKey: "2280e7e3fb062bd9ef00f3b40a1f8746", language: "en-US", sortBy: "popularity.desc", isAdult: false, includeVideo: false, page: 1).params
        
        worker = ListMovieWorker()
        worker?.generateMovieList(param: params){ result in
            switch result {
            case .success(let movieList):
                let response = MovieModel.ViewModel(listMovie: movieList, movie: nil)
                print(response)
            //                self.presenter?.presentMovie(response: response)
            case .failure(_):
                break
            }
        }
    }
    
    func getNowPlayingMovie() {
        let params = MovieModel.Request.init(apiKey: "2280e7e3fb062bd9ef00f3b40a1f8746", language: "en-US", sortBy: "popularity.desc", isAdult: false, includeVideo: false, page: 1).params
        
        worker = ListMovieWorker()
        worker?.fetchNowPlayingMovie(param: params){ result in
            switch result {
            case .success(let movieList):
                let response = MovieModel.ViewModel(listMovie: movieList, movie: nil)
                self.output.presentNowPlayingMovie(response: response)
            case .failure(_):
                break
            }
        }
    }
    
    func getUpcomingMovie() {
        let params = MovieModel.Request.init(apiKey: "2280e7e3fb062bd9ef00f3b40a1f8746", language: "en-US", sortBy: "popularity.desc", isAdult: false, includeVideo: false, page: 1).params
        
        worker = ListMovieWorker()
        worker?.fetchUpcomingMovie(param: params){ result in
            switch result {
            case .success(let movieList):
                let response = MovieModel.ViewModel(listMovie: movieList, movie: nil)
                self.output.presentUpcomingMovie(response: response)
            case .failure(_):
                break
            }
        }
    }
    
    func showDetail(movie: MovieModel.Movie2) {
        self.detailMovie = movie
        let response = MovieModel.ViewModel(listMovie: nil, movie: movie)
        output.presentDetailMovie(response: response)
    }
}