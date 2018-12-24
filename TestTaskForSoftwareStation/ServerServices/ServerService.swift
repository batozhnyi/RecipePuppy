//
//  ServerService.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/12/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

class ServerService {

    class func downloadRecipes(with numberPage: Int,
                         completionHandler: @escaping (JsonStruct) -> Void,
                         completionError: @escaping (Error) -> Void) {
        
        let path = "http://www.recipepuppy.com/api/"
        let queryPath = "p"

        // Created url
        guard let url = URL(string: path) else {
            someError(inputError: "Creating url is failed") { (error) in
                completionError(error)
            }
            return
        }

        // Created url query components
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: queryPath, value: String(numberPage))]

        // Created url with query components
        guard let urlWithQuery = components?.url else {
            someError(inputError: "Creating url with query components is failed") { (error) in
                completionError(error)
            }
            return
        }

        // Created url session data task and get optional json
        URLSession.shared.dataTask(with: urlWithQuery) { (data, response, error) in

            if let unwrapError = error {
                completionError(unwrapError)
                print("Error: - \(unwrapError.localizedDescription)")
            } else if let jsonData = data,
                let getResponse = response as? HTTPURLResponse,
                getResponse.statusCode == 200 {

                do {
                    let decodeData = try JSONDecoder().decode(JsonStruct.self, from: jsonData)
                    completionHandler(decodeData)
                } catch let jsonError {
                    print("Error: - \(jsonError)")
                    completionError(jsonError)
                }

            }
        }.resume()

    }

    class func someError(inputError: String,
                         completionError: @escaping (Error) -> Void) {
        let inputError: String = inputError
        let customError = NSError(domain: "com.batozhnyi.TestTaskForSoftwareStation.customError",
                                  code: 404,
                                  userInfo: ["Error":inputError])
        completionError(customError)
    }


}
