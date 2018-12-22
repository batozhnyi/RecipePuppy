//
//  DataManager.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/21/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import Foundation

class DataManager {

    // Download json data
    class func downloadRecipe(_ completionHandler: @escaping ([Recipe]) -> Void ) {

        var pageNumber = 1

        ServerRecipe.getRecipe(with: pageNumber, completionHandler: { (recipes) in

            guard let openRecipeResult = recipes.results else { return }
            print(openRecipeResult)
            pageNumber = pageNumber + 1
            completionHandler(openRecipeResult)

//            if let openRecipeResult = recipes.results {
//                var returnedRecipes: [Recipe] = []
//                for recipeEntity in openRecipeResult {
//                    var recipe = Recipe()
//                    recipe.title = recipeEntity.title ?? ""
//                    recipe.href = recipeEntity.href ?? ""
//                    recipe.ingredients = recipeEntity.ingredients ?? ""
//                    recipe.thumbnail = recipeEntity.thumbnail ?? ""
//
//                    returnedRecipes.append(recipe)
//                }
//            pageNumber = pageNumber + 1
//            completionHandler(openRecipeResult)
//            }

        })
    }

    class func getRecipes(countNumber: @escaping ((Int) -> ()),
                    complitionHandler: @escaping ([Recipe]) -> Void) {
        DispatchQueue.main.async {
            let recipeEntities = try? RecipeEntity.getAllRecipes(context: AppDelegate.viewContext)

            var countNumberOfRecipes = 0

            if let recipes = recipeEntities,
                recipes.count > 0 {
                    countNumberOfRecipes = recipes.count
                    var returnedRecipes: [Recipe] = []
                    for recipeEntity in recipes {
                        var recipe = Recipe()
                        recipe.title = recipeEntity.title
                        recipe.href = recipeEntity.href
                        recipe.ingredients = recipeEntity.ingredients
                        recipe.thumbnail = recipeEntity.thumbnail

                        returnedRecipes.append(recipe)
                }
                countNumber(countNumberOfRecipes)
                complitionHandler(returnedRecipes)
            } else {
                downloadRecipe({ (recipes) in

                    AppDelegate.coreDataContainer.performBackgroundTask({ (context) in

                        for recipe in recipes {
                            try? RecipeEntity.findOrCreate(recipe: recipe,
                                                           context: context)
                        }
                        try? context.save()
                        complitionHandler(recipes)
                    })
                })
            }
        }
    }
}
