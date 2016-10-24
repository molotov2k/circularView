//
//  ViewController.swift
//  Youplus
//
//  Created by Astarta on 10/12/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate  {
    
    let navBar = UINavigationBar()
    let bottomView = UIView()
    let bottomViewMenuButton = UIButton()
    let tintView = UIView()
    let categoryLabel = UILabel()
    var collectionView: UICollectionView?
    
    var collectionHidden = true
    var categories: [Type] = []
    
    var middleCategoriesElementIndex: Int {
        return self.categories.count / 2
    }
    
    var tableViewRowHeight: CGFloat {
        return self.view.bounds.height / 4
    }
    
    var centeredOffset: CGFloat {
        return Constants.initialOffset + Constants.offsetPerCell * CGFloat(self.middleCategoriesElementIndex)
    }
    
    var middleViewableItemIndex: Int {
        if let collection = self.collectionView {
            let visibleItemIndexes = collection.indexPathsForVisibleItems.sorted()
            if visibleItemIndexes.isEmpty {
                return 0
            }
            let indexPathForMiddleElement = visibleItemIndexes[visibleItemIndexes.count / 2]
            return indexPathForMiddleElement.row
        } else {
            return 0
        }
    }

    lazy var fetchedResultsController: NSFetchedResultsController<Type> = {
        let context = CoreDataHelper().persistentContainer.viewContext
        let typeFetchRequest = NSFetchRequest<Type>(entityName: Constants.typeEntity)
        let sortDescriptor = NSSortDescriptor(key: Constants.index, ascending: true)
        typeFetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController<Type>(
            fetchRequest: typeFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCategories()
        self.setupTableView()
        self.setupBottomView()
        self.setupNavigationBar()
    }
    
    
// MARK - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.categories[self.middleCategoriesElementIndex].items.count
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! TableViewCell
        let items = self.categories[self.middleCategoriesElementIndex].items
        let itemsArray = Array(items).sorted {$0.name < $1.name}
        
        //cell.label.text = itemsArray[indexPath.row].name
        cell.nameLabel.text = itemsArray[0].name
        cell.priceLabel.text = "$" + String(itemsArray[0].originalPrice)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var newBottomViewFrame = self.bottomView.frame
        var newBottomViewButtonFrame = self.bottomViewMenuButton.frame
        
        newBottomViewFrame.origin.y = self.tableView.contentOffset.y + self.tableView.bounds.height - self.bottomView.bounds.height
        newBottomViewButtonFrame.origin.y = self.tableView.contentOffset.y + self.tableView.bounds.height - self.bottomViewMenuButton.bounds.height / 2
        self.navBar.frame.origin.y = self.tableView.contentOffset.y
        
        self.bottomView.frame = newBottomViewFrame
        self.bottomViewMenuButton.frame = newBottomViewButtonFrame
        
        self.tableView.bringSubview(toFront: self.bottomView)
        self.tableView.bringSubview(toFront: self.bottomViewMenuButton)
        
    }
  
    
// MARK - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellReuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        let categoryImage = UIImage(data: self.categories[indexPath.row].image as! Data)
        let tintableImage = categoryImage?.withRenderingMode(.alwaysTemplate)
        cell.imageView.image = tintableImage
        
        
        if indexPath.row != self.middleCategoriesElementIndex {
            cell.imageView.tintColor = .cyan
        } else {
            cell.imageView.tintColor = .white
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemOffset = Constants.initialOffset + Constants.offsetPerCell * CGFloat(indexPath.row)
        self.collectionView?.setContentOffset(CGPoint.init(x: selectedItemOffset, y: 0), animated: true)
        self.hideController()
    }
    
    
// MARK - Scroll View overrides
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.collectionView {
            self.scrollCollectionView()
        } else if scrollView == self.tableView {
            self.scrollTableView()
        }
    }
    
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.scrollCollectionView()
        } else if scrollView == self.tableView {
            self.scrollTableView()
        }
    }
    
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let numberOfCellsScrolled = Int((self.centeredOffset - scrollView.contentOffset.x) / Constants.offsetPerCell)
            self.moveCategoriesElements(numberOfElementsToMove: numberOfCellsScrolled)
            self.collectionView?.reloadData()
            self.collectionView?.setContentOffset(CGPoint.init(x: self.centeredOffset, y: 0), animated: false)
        }
    }
    
    
}

