//
//  RecipeController.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/12/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import UIKit

class RecipeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var recipeNumber = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        ServerRecipe.getRecipe(with: 1, completionHandler: { (recipes) in

            guard let openRecipeResult = recipes.results else { return }
                print(openRecipeResult)
        })
    }

    // Number of recipes
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return recipeNumber
    }

    // Cell of recipes
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellRecipe",
                                                      for: indexPath) as! CollectionViewCell
        cell.label.text = receipeTitle
        cell.text.text = ingredients
        cell.image.image = UIImage(named: thumbnail)
        
        return cell
    }

    // Auto-width for cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }


}

