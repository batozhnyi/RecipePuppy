//
//  ImagesManager.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/26/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation
import UIKit

class ImagesManager {

    static var imageCache = NSCache<NSString, UIImage>()

    class func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else { return }

                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    completion(image)
                }
                }.resume()
        }
    }
}
