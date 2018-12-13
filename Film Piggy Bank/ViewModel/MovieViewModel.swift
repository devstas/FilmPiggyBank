//
//  MovieViewModel.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import Foundation
import RealmSwift

class MovieViewModel {
    
    var networkStatus = true
    private let moviesApi = TheMovieAPI()
    private var viewModelForCell = [DetailViewModel]()
    
    func updateMovies(searchText: String, _ completion: @escaping () -> Void ) {
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if searchText != "" {
            moviesApi.searchMovie(query: searchText) { (movies) in
                if movies != nil {
                    // data downloaded from network
                    self.networkStatus = true
                    self.viewModelForCell = movies!.results.map{ DetailViewModel(film: $0) }
                    completion()
                } else {
                    // data not received from the network
                    self.networkStatus = false
                    self.showMoviesFromDB { completion() }
                }
            }
        } else {
            self.showMoviesFromDB { completion()}
        }
    }
    
    func showMoviesFromDB(onlyFavorite: Bool = false, _ completion: @escaping () -> Void ) {
        
        let realm = try! Realm()
        var dbResults: Results<RealmMovies>!
        let response = onlyFavorite ? "favorite == true" : "id > 0"
        dbResults = realm.objects(RealmMovies.self).filter(response)
        self.viewModelForCell = dbResults.map{ DetailViewModel(film: $0) }
        DispatchQueue.main.async {
            completion()
        }
        
    }
    
    func getCountOfCell() -> Int {
        return viewModelForCell.count
    }
    
    func getCellViewModel(index: Int) -> DetailViewModel? {
        guard index < viewModelForCell.count else { return nil }
        return viewModelForCell[index]
    }
    
}
