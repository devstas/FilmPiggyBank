//
//  MoviedbAPI.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import Foundation

public class TheMovieAPI {
    
    //private let apiKey = "6f6854233eeb5ed6f220e2da4a3c57eb"
    private let baseUrl = "https://api.themoviedb.org/3/search/movie"
    private var requestParam = [
        "api_key"   : "6f6854233eeb5ed6f220e2da4a3c57eb",
        "language"  : "ru",
        "query"     : ""]
    
    func searchMovie(query: String, completion: @escaping (JSONMovied?) -> ()) {
        print("[searchMovie]: start load data ...")
        requestParam["query"] = query
        let urlRequest = self.getUrlRequest(url: baseUrl, parameters: requestParam)
        func decodeFunc(data: Data) -> JSONMovied? {
            return try? JSONDecoder().decode(JSONMovied.self, from: data)
        }
        Network.shared.getData(urlRequest: urlRequest, decodeFunc: decodeFunc) { (receivedData) in
            let data = receivedData as? JSONMovied
            completion(data)
        }
    }
    
    func getUrlRequest(url: String, parameters: [String: String]) -> URLRequest {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
    
}
