//
//  RecipeEntity.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/21/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject {

    // Get all of recipes from Data Base
    class func getAllRecipes(context: NSManagedObjectContext) throws -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()

        do {
            let recipes = try context.fetch(request)
            return recipes
        } catch {
            throw error
        }
    }

    class func findOrCreate(recipe: Recipe,
                            context: NSManagedObjectContext) throws -> RecipeEntity {

        // Looking for recipe in Data Base
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "href == %@", recipe.href!)

        do {
            let recipes = try context.fetch(request)
            if recipes.count > 0 {
                assert(recipes.count == 1, "There are few recipes related to one href")
                return recipes[0]
            }
        } catch {
            throw error
        }

        // Create recipe if we didnt find it
        let recipeEntity = RecipeEntity(context: context)
        recipeEntity.title = recipe.title
        recipeEntity.ingredients = recipe.ingredients
        recipeEntity.thumbnail = recipe.thumbnail
        recipeEntity.href = recipe.href

        return recipeEntity
    }
}
