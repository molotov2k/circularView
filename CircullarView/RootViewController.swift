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
    var collectionView: UICollectionView?
    var collectionHidden = true
    let categoryLabel = UILabel()

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
    
    var categories: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCategories()
        self.setupTableView()
        self.setupBottomView()
        self.setupNavigationBar()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }
    
    }
    
    
// MARK - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! TableViewCell
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height / 4
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
        
        let name = self.categories[indexPath.row % (self.categories.count / 3)]
        
        cell.backgroundColor = .cyan
        cell.label.text = String(name[name.startIndex])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
    }
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        print("Visible indexes before scroll: \(self.collectionView?.indexPathsForVisibleItems)")
        
        let fullyScrolledContentOffset:CGFloat = self.collectionView!.frame.size.width / CGFloat(self.categories.count / 3)
        
        if (scrollView.contentOffset.x >= fullyScrolledContentOffset) {
            print("scrolling right")
            if self.categories.count > 2 {
                self.reverseArray(array: &self.categories, startIndex: 0, endIndex: self.categories.count - 1)
                self.reverseArray(array: &self.categories, startIndex: 0, endIndex: 1)
                self.reverseArray(array: &self.categories, startIndex: 2, endIndex: self.categories.count - 1)
                self.collectionView?.reloadData()
                let indexPath = IndexPath(row: self.categories.count / 3, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: false)
            }
            
        } else if (scrollView.contentOffset.x == 0) {
            print("scrolling left")
            if self.categories.count > 2 {
                self.reverseArray(array: &self.categories, startIndex: 0, endIndex: self.categories.count - 1)
                self.reverseArray(array: &self.categories, startIndex: 0, endIndex: self.categories.count - 3)
                self.reverseArray(array: &self.categories, startIndex: self.categories.count - 2, endIndex: self.categories.count - 1)
                self.collectionView?.reloadData()
                let indexPath = IndexPath(row: self.categories.count / 3 * 2, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
            }
            
        }
    }
    
    
}

