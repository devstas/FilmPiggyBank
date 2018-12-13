//
//  RealmFilm.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMovies: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var favorite = false
    @objc dynamic var voteAverage = ""
    @objc dynamic var title = ""
    @objc dynamic var info = ""
    @objc dynamic var overview = ""
    @objc dynamic var imageURL: String? = nil
    @objc dynamic var image: Data? = nil
    
    //not used in test project, but can create garbage collector to clean database
    @objc dynamic var countShow = 0
    @objc dynamic var creationDate: Date? = nil
}
