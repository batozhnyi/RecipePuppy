//
//  RecipePuppyStruct.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/13/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

struct RecipePuppy: Decodable {
    var title: String?
    var version: Double?
    var href: String?
    var results: [Recipe]?
}

struct Recipe: Decodable {
    var title: String?
    var href: String?
    var ingredients: String?
    var thumbnail: String?
}

struct nonOptionalRecipe: Decodable {
    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
}
