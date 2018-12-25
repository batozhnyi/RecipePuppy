//
//  DataManager.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/21/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

class DataManager {

    static var pageNumber: Int = {
        return 1
    }()

    typealias ErrorCompletion = (Error) -> (Void)

    class func getRecipes(_ complitionHandler: @escaping ([RecipeStruct]) -> Void,
                          completionError: @escaping ErrorCompletion) {

        if let databaseRecipes = recipesFromDatabase() {
            complitionHandler(databaseRecipes)

        } else {

            downloadRecipe({ (recipes) in
                AppDelegate.coreDataContainer.performBackgroundTask({ (context) in

                    for recipe in recipes {
                        _ = try? RecipeEntity.findOrCreate(recipe: recipe,
                                                           context: context)
                    }
                    try? context.save()
                    complitionHandler(recipes)
                })
            }, completionError: completionError)
        }
    }

    // Download JSON Data from Rest API
    class func downloadRecipe(_ completionHandler: @escaping ([RecipeStruct]) -> Void,
                              completionError: @escaping ErrorCompletion) {

        ServerService.downloadRecipes(with: pageNumber,
                               completionHandler: { (recipes) in
            guard let openRecipeResult = recipes.results else { return }
            pageNumber = pageNumber + 1
            print(pageNumber)
            completionHandler(openRecipeResult)
        }, completionError: completionError)
    }

    // Get all recepies from Data Base
    class func recipesFromDatabase() -> [RecipeStruct]? {
        let recipeEntities = try? RecipeEntity.getAllRecipes(context: AppDelegate.coreDataContainer.viewContext)

        if let recipes = recipeEntities,
            recipes.count > 0 {
            var returnedRecipes: [RecipeStruct] = []

            for recipeEntity in recipes {
                var recipe = RecipeStruct()
                recipe.title = recipeEntity.title
                recipe.href = recipeEntity.href
                recipe.ingredients = recipeEntity.ingredients
                recipe.thumbnail = recipeEntity.thumbnail

                returnedRecipes.append(recipe)
            }

            return returnedRecipes
        } else {
            return nil
        }
    }
}
