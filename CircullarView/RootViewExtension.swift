//
//  RootViewExtension.swift
//  Youplus
//
//  Created by Astarta on 10/13/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit
import CoreData

extension RootViewController {

    
// MARK - views setup
    
    func setupTableView() {
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.alwaysBounceVertical = false
    }
    
    
    func setupBottomView() {
        
        self.bottomView.frame = CGRect(x: 0,
                                       y: self.view.bounds.height - Constants.bottonViewHeight + UIApplication.shared.statusBarFrame.height,
                                       width: self.view.bounds.width,
                                       height: Constants.bottonViewHeight)
        self.bottomView.backgroundColor = .black
        self.bottomView.alpha = 0.1
        
        self.bottomViewMenuButton.frame = CGRect(x: (self.bottomView.bounds.width - self.bottomView.bounds.height * 2) / 2,
                                                 y: self.view.bounds.height - Constants.bottonViewHeight + UIApplication.shared.statusBarFrame.height,
                                                 width: Constants.bottonViewHeight * 2,
                                                 height: Constants.bottonViewHeight * 2)
        self.bottomViewMenuButton.layer.cornerRadius = self.bottomViewMenuButton.bounds.width / 2
        self.bottomViewMenuButton.backgroundColor = .blue
        self.bottomViewMenuButton.addTarget(self, action: #selector(RootViewController.controllerButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.bottomViewMenuButton)
    
    }
    
    
    func setupNavigationBar() {
        self.navBar.frame = CGRect(x: 0,
                                   y: 0,
                                   width: self.view.bounds.width,
                                   height: Constants.navBarHeight)
        self.navBar.alpha = 0.75
        let navItem = UINavigationItem(title: "THE BAR")
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(self.navBar)
    }
    
    
    func setupCollectionView() {
        self.collectionView?.removeFromSuperview()
        let layout = DSCircularLayout()
        
        let collectionViewFrame = CGRect(x: (self.view.bounds.width - Constants.collectionViewRadius) / 2,
                                         y: self.tableView.contentOffset.y + self.view.bounds.height + UIApplication.shared.statusBarFrame.height,
                                         width: Constants.collectionViewRadius,
                                         height: Constants.collectionViewRadius)
        
        layout.initWithCentre(CGPoint(x: collectionViewFrame.width / 2, y: collectionViewFrame.height / 2),
                              radius: Constants.collectionViewRadius / 2.5,
                              itemSize: CGSize(width: 40, height: 40),
                              andAngularSpacing: 60)
        layout.setStartAngle(CGFloat(M_PI), endAngle: 0)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.rotateItems = false
        
        self.collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionCellReuseIdentifier)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = .white
        self.collectionView?.layer.cornerRadius = (self.collectionView?.bounds.width)! / 2
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.alpha = 0.9
        self.collectionView?.layoutIfNeeded()
        self.view.addSubview(self.collectionView!)
        self.view.bringSubview(toFront: self.collectionView!)
        self.collectionView?.contentOffset = CGPoint.init(x: self.centeredOffset, y: 0)
    }
    
    
    func setupTintView() {
        self.tintView.frame = CGRect(x: 0,
                                     y: self.tableView.contentOffset.y,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        self.tintView.backgroundColor = .gray
        self.tintView.alpha = 0.0
        self.view.addSubview(tintView)
    }
    
    
    func setupCategoryLabel() {
        self.categoryLabel.frame = CGRect(x: self.view.bounds.width / 2 - 45,
                                          y: self.tableView.contentOffset.y + self.view.bounds.height + UIApplication.shared.statusBarFrame.height - Constants.bottonViewHeight - 50 + Constants.collectionViewRadius / 2,
                                          width: 90,
                                          height: 30)
        self.categoryLabel.textAlignment = .center
        self.categoryLabel.textColor = .red
        self.view.addSubview(self.categoryLabel)
    }
    
    
// MARK - CoreData functionality
    
    func fetchCategories() {
        let coreDataHelper = CoreDataHelper()
        let request:NSFetchRequest<Type> = Type.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: Constants.index, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let context = coreDataHelper.persistentContainer.viewContext
        
        do {
            let types = try context.fetch(request)
            self.categories.removeAll()
            for type in types {
                self.categories.append(type.name)
            }
            self.categories += self.categories + self.categories
            self.collectionView?.reloadData()
        } catch {
            fatalError("Error fetching CoreData categories: \(error)")
        }
        
    }

    
// MARK - controller appearance implementation
    
    func controllerButtonPressed() {
        if self.collectionHidden {
            self.showController()
        } else {
            self.hideController()
        }
    }
    
    
    func showController() {
        self.view.isUserInteractionEnabled = false
        self.tableView.isScrollEnabled = false
        self.bottomView.removeFromSuperview()
        self.setupTintView()
        self.setupCollectionView()
        self.setupCategoryLabel()
        self.view.bringSubview(toFront: self.collectionView!)

        UIView.animate(withDuration: 0.5, animations: { 
            self.collectionView?.frame.origin.y -= self.collectionView!.bounds.height / 2
            self.categoryLabel.frame.origin.y -= self.collectionView!.bounds.height / 2
            self.tintView.alpha = 0.7
            }) { (true) in
                self.view.isUserInteractionEnabled = true
                self.collectionHidden = false
        }
        
        self.view.bringSubview(toFront: self.bottomViewMenuButton)
        
    }
    
    
    func hideController() {
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(self.bottomView)
        self.view.bringSubview(toFront: self.bottomViewMenuButton)
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.collectionView?.frame.origin.y += self.collectionView!.bounds.width / 2
            self.categoryLabel.frame.origin.y += self.collectionView!.bounds.width / 2
            self.tintView.alpha = 0.0
            }) { (true) in
                self.collectionView?.removeFromSuperview()
                self.tintView.removeFromSuperview()
                self.categoryLabel.removeFromSuperview()
                self.tableView.isScrollEnabled = true
                self.view.isUserInteractionEnabled = true
                self.collectionHidden = true
        }
        
    }
  
    
// MARK - infinite scroll
    
    func moveCategoriesElements(numberOfElementsToMove: Int) {
        if numberOfElementsToMove > 0 {
            let elementToMove = self.categories.removeLast()
            self.categories.insert(elementToMove, at: 0)
            self.moveCategoriesElements(numberOfElementsToMove: numberOfElementsToMove - 1)
        } else if numberOfElementsToMove < 0 {
            let elementToMove = self.categories.removeFirst()
            self.categories.append(elementToMove)
            self.moveCategoriesElements(numberOfElementsToMove: numberOfElementsToMove + 1)
        }
    }
    
    
}

