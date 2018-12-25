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

    var fetchMore = false

    lazy var fetchedResultsController: NSFetchedResultsController<RecipeEntity> = {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        let managedContext = AppDelegate.viewContext
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<RecipeEntity>(fetchRequest: fetchRequest,
                                                                                managedObjectContext: managedContext,
                                                                                sectionNameKeyPath: nil,
                                                                                cacheName: nil)
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .userInteractive).async {
            DataManager.getRecipes({ (recipes) in
                DispatchQueue.main.async {
                    do {
                        try self.fetchedResultsController.performFetch()
                    } catch let err {
                        print(err)
                    }

                    self.collectionView.reloadData()
                }
            }) { (error) -> (Void) in
                print(error)
            }
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
            let ingredients = importRecipes.ingredients,
            let thumbnail = importRecipes.thumbnail {

            cell.label.text = receipeTitle
            cell.text.text = ingredients

            if let url = URL(string: thumbnail) {
                DispatchQueue.global(qos: .userInteractive).async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        cell.image.image = UIImage(data: data!)
                    }
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

    // Export data of item to prepare
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        let importRecipes = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "PopupSegue",
                     sender: importRecipes)
    }

    // Send url and title to Popup View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopupSegue" {
            if let PopUpViewController = segue.destination as? PopUpViewController {
                if let openSender = sender as? RecipeEntity {
                    if let openHrefSender = openSender.href,
                        let openTitleSender = openSender.title {
                            PopUpViewController.recipeHref = openHrefSender
                            PopUpViewController.recipeTitle = openTitleSender
                    }

                }

            }
        }
    }

    // Check scroll and call next pecipes
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !fetchMore {
                if Reachability.isConnectedToNetwork(){
                    beginBatchFetch()
                }
            }
        }
    }

    // Download next recipes from API and show
    func beginBatchFetch() {
        fetchMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0,
                                      execute: {
                                        DispatchQueue.global(qos: .userInteractive).async {
                                            DataManager.downloadRecipe({ (recipes) in
                                                AppDelegate.coreDataContainer.performBackgroundTask({ (context) in

                                                    for recipe in recipes {
                                                        _ = try? RecipeEntity.findOrCreate(recipe: recipe,
                                                                                           context: context)
                                                    }
                                                    try? context.save()
                                                })
                                            }, completionError: { (error) -> (Void) in
                                                print(error)
                                            })
                                            DispatchQueue.main.async {
                                                do {
                                                    try self.fetchedResultsController.performFetch()
                                                } catch let err {
                                                    print(err)
                                                }
                                                self.fetchMore = false
                                                self.collectionView.reloadData()
                                            }
                                        }
                                })
    }
}
