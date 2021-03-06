//
//  ShowDetailMoviePresenter.swift
//  Clean Swift
//
//  Created by Fabianus Hendy Evan on 11/04/19.
//  Copyright (c) 2019 Fabianus Hendy Evan. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailMoviePresentationLogic
{
    func presentMovie(response: DetailMovie.Something.Response)
}

class DetailMoviePresenter: DetailMoviePresentationLogic
{
    weak var viewController: DetailMovieDisplayLogic?
    
    // MARK: Do something
    
    func presentMovie(response: DetailMovie.Something.Response) {
        let viewModel = DetailMovie.Something.ViewModel(movie: response.movie)
        viewController?.displayDetailMovie(viewModel: viewModel)
    }
}
