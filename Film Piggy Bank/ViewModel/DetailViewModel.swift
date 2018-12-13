//
//  DetailViewModel.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//
import UIKit
import RealmSwift

class DetailViewModel {
    
    let imageURL: URL? 
    var image: UIImage?
    let id: Int
    let filmName: String
    let filmDescription: String
    let vote: String
    let info: String
    var favorite: Bool = false
    
    let baseUrlForDownloadImage = "https://image.tmdb.org/t/p/w500"
    lazy var realm = try! Realm()
    
    public init(film: Movie) {
        self.imageURL = (film.posterPath != nil)
            ? URL(string: baseUrlForDownloadImage + film.posterPath!)
            : nil
        
        self.image = nil
        self.info  = """
        Год выпуска: \(film.releaseDate)
        Язык: \(film.originalLanguage)
        Рейтинг: \(film.voteAverage)
        Голосв: \(film.voteCount)
        """
        self.id = film.id
        self.filmName = film.title
        self.filmDescription = film.overview
        self.vote = String(film.voteAverage)
        
        if let res = realm.objects(RealmMovies.self).filter("id = \(self.id)").first {
            self.favorite = res.favorite
        }
    }
    
    public init(film: RealmMovies) {
        self.image = film.image != nil ? UIImage(data: film.image!) : nil
        self.imageURL = URL(string: film.imageURL ?? "")
        self.favorite = film.favorite
        self.info  = film.info
        self.id = film.id
        self.filmName = film.title
        self.filmDescription = film.overview
        self.vote = film.voteAverage
    }
    
    // MARK: - Private method
    private func createDBObjectFromViewModel() -> RealmMovies {
        let film = RealmMovies()
        film.favorite = favorite
        film.id = id
        film.title = filmName
        film.info = info
        film.voteAverage = vote
        film.overview = filmDescription
        film.imageURL = imageURL?.absoluteString
        film.image = image?.jpegData(compressionQuality: 0.6)
        return film
    }
    
    private func saveDBObjectToBase(object: RealmMovies) {
        do {
            try self.realm.write {
                self.realm.add(object)
            }
        } catch let error as NSError {
            print("[Realm]: \(error.localizedDescription)")
        }
    }
    
    private func existDBObjectInBase(id: Int) -> Bool {
        return (realm.objects(RealmMovies.self).filter("id = \(id)").first != nil)
    }
    
    
    // MARK: - API
    func saveViewModelToDataBase() {
        if !existDBObjectInBase(id: self.id) {
            // film NOT exist in db
            let filmObject = createDBObjectFromViewModel()
            saveDBObjectToBase(object: filmObject)
        }
    }
    
    func saveFavoriteToDataBase() {
        if let dbResults = realm.objects(RealmMovies.self).filter("id = \(self.id)").first {
            // film exist in db
            try! realm.write {
                dbResults.favorite = favorite
            }
        } else {
            let filmObject = createDBObjectFromViewModel()
            saveDBObjectToBase(object: filmObject)
        }
    }
    
}
