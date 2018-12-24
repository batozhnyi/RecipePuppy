//
//  RecipeController.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/12/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import UIKit
import CoreData

class RecipeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    lazy var fetchedResultsController: NSFetchedResultsController<RecipeEntity> = {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        let managedContext = AppDelegate.viewContext
        let sortDescriptor = NSSortDescriptor(key: "href", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<RecipeEntity>(fetchRequest: fetchRequest,
                                                                          managedObjectContext: managedContext,
                                                                          sectionNameKeyPath: nil,
                                                                          cacheName: nil)
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }

    // Number of recipes
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }

    // Cell of recipes
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellRecipe",
                                                      for: indexPath) as! CollectionViewCell

        let importRecipes = fetchedResultsController.object(at: indexPath)

        if let receipeTitle = importRecipes.title,
            let href = importRecipes.href,
            let ingredients = importRecipes.ingredients,
            let thumbnail = importRecipes.thumbnail {

            cell.label.text = receipeTitle
            cell.text.text = ingredients

            let url = URL(string: thumbnail)

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: data!)
                }
            }

        } else {
            print("Some data is missing")
        }

        return cell
    }

    // Auto-width for cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 85)
    }

    

}

