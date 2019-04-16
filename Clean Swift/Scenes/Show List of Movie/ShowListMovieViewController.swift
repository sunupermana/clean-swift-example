//
//  ShowListMovieViewController.swift
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

protocol ShowListMovieDisplayLogic: class
{
    func displayUpcomingMovie(viewModel: MovieModel.ViewModel)
    func displayNowPlayingMovie(viewModel: MovieModel.ViewModel)
    func displayDetailMovie(viewModel: MovieModel.ViewModel)
}

class ShowListMovieViewController: UIViewController
{
    var interactor: ShowListMovieBusinessLogic?
    var router: (NSObjectProtocol & ShowListMovieRoutingLogic & ShowListMovieDataPassing)?
    
    @IBOutlet weak var movieListTableView: UITableView!
    
    var movieHeader = ["Now Showing", "Upcoming"]
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ShowListMovieInteractor()
        let presenter = ShowListMoviePresenter()
        let router = ShowListMovieRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    var upcomingMovie: [MovieModel.Movie2] = []
    var nowPlayingMovie: [MovieModel.Movie2] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        movieListTableView.register(UINib(nibName: "ListMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        movieListTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        movieListTableView.rowHeight            = UITableView.automaticDimension
        movieListTableView.estimatedRowHeight   = UITableView.automaticDimension
        
        getNowPlayingMovie()
        getUpcomingMovie()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Do something
    
    func getUpcomingMovie(){
        interactor?.getUpcomingMovie()
    }
    
    func getNowPlayingMovie(){
        interactor?.getNowPlayingMovie()
    }
}

extension ShowListMovieViewController: ShowListMovieDisplayLogic {
    
    func displayUpcomingMovie(viewModel: MovieModel.ViewModel) {
        upcomingMovie = viewModel.listMovie!
        self.movieListTableView.reloadData()
    }
    
    func displayNowPlayingMovie(viewModel: MovieModel.ViewModel) {
        nowPlayingMovie = viewModel.listMovie!
        self.movieListTableView.reloadData()
    }
    
    func displayDetailMovie(viewModel: MovieModel.ViewModel) {
        router?.routeToDetailMovie()
    }
}

extension ShowListMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ListMovieTableViewCell
            if indexPath.row == 1 {
                cell.setupCell(listMovie: nowPlayingMovie)
            } else {
                cell.setupCell(listMovie: upcomingMovie)
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderTableViewCell
            cell.setupCell(movieHeader[indexPath.row/2])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 44
        } else {
            return 440
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ShowListMovieViewController: MovieSelection {
    func didSelectMovie(_ movie: MovieModel.Movie2) {
        interactor?.showDetail(movie: movie)
    }
}
