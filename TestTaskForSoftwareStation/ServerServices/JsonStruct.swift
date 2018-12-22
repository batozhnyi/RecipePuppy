//
//  JsonStruct.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/13/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

struct JsonStruct: Decodable {
    var title: String?
    var version: Double?
    var href: String?
    var results: [RecipeStruct]?
}

struct RecipeStruct: Decodable {
    var title: String?
    var href: String?
    var ingredients: String?
    var thumbnail: String?
}
