//
//  ServerRecipe.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/12/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

class ServerRecipe {

    class func getRecipe(with numberPage: Int,
                         completionHandler: @escaping (RecipePuppy) -> Void ) {
        
        let path = "http://www.recipepuppy.com/api/"
        let queryPath = "p"

        // Created url
        guard let url = URL(string: path) else { return }

        // Created url query components
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: queryPath, value: String(numberPage))]

        // Created url with query components
        guard let urlWithQuery = components?.url else { return }

        // Created url session data task and get optional json
        URLSession.shared.dataTask(with: urlWithQuery) { (data, response, error) in

            if let unwrapError = error {
                print("Error: - \(unwrapError.localizedDescription)")
            } else if let jsonData = data,
                let getResponse = response as? HTTPURLResponse,
                getResponse.statusCode == 200 {

                do {
                    let decodeData = try JSONDecoder().decode(RecipePuppy.self, from: jsonData)
                    completionHandler(decodeData)
                } catch let jsonError {
                    print("Error: - \(jsonError)")
                }


            }
        }.resume()
    }
}

