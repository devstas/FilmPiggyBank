//
//  NetworkManeger.swift
//  Film Piggy Bank
//
//  Created by Serov Stas on 11/12/2018.
//  Copyright © 2018 Serov Stas. All rights reserved.
//

import UIKit

class Network {
     
    private init() {}
    static let shared  = Network()
    
    // MARK: - Send request
    func getData(urlRequest: URLRequest, decodeFunc: @escaping (_ data: Data) -> Any?, completion: @escaping (Any?) -> ()) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("[HTTPRequest]: status code = \(httpStatus.statusCode)")
                completion(nil)
                return
            }
            guard let decodeData = decodeFunc(data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(decodeData)
            }
            }.resume()
    }
    
    
    // MARK: - Download image
    private var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: URL, useCache: Bool = true, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString), useCache {
            //print("Load image from cache [url]: \(url.absoluteString)")
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad , timeoutInterval: 20)
            URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                
                guard error == nil, data != nil else {
                    completion(nil)
                    return
                }
                guard let image = UIImage(data: data!) else {
                    completion(nil)
                    return
                }
                if useCache {
                    self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
                //print("Load image from network [url]: \(url.absoluteString)")
                DispatchQueue.main.async {
                    completion(image)
                }
            }).resume()
        }
    }
    
}
