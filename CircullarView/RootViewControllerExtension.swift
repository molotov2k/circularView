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
        self.tableView.bounces = false
        self.tableView.allowsSelection = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
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
        self.bottomViewMenuButton.backgroundColor = .black
        self.bottomViewMenuButton.addTarget(self, action: #selector(RootViewController.controllerButtonPressed), for: .touchUpInside)
        let image = UIImage(named: "plus512")?.withRenderingMode(.alwaysTemplate)
        self.bottomViewMenuButton.setImage(image, for: .normal)
        self.bottomViewMenuButton.tintColor = .cyan
        
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.bottomViewMenuButton)
    
    }
    
    
    func setupNavigationBar() {
        self.navBar.frame = CGRect(x: 0,
                                   y: 0,
                                   width: self.view.bounds.width,
                                   height: Constants.navBarHeight)
        self.navBar.alpha = 0.75
        let navItem = UINavigationItem(title: "Circular View")
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(self.navBar)
    }
    
    
    func setupCollectionView() {
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
        self.collectionView?.backgroundColor = .black
        self.collectionView?.layer.cornerRadius = (self.collectionView?.bounds.width)! / 2
        self.collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.collectionView?.alpha = 0.85
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.hideController))
        self.tintView.addGestureRecognizer(gestureRecognizer)
        self.view.addSubview(tintView)
    }
    
    
    func setupCategoryLabel() {
        self.categoryLabel.frame = CGRect(x: self.view.bounds.width / 2 - 45,
                                          y: self.tableView.contentOffset.y + self.view.bounds.height + UIApplication.shared.statusBarFrame.height - Constants.bottonViewHeight - 55 + Constants.collectionViewRadius / 2,
                                          width: 90,
                                          height: 30)
        self.categoryLabel.textAlignment = .center
        self.categoryLabel.textColor = .white
        self.categoryLabel.text = self.categories[self.middleCategoriesElementIndex].name
        self.view.addSubview(self.categoryLabel)
    }
    
    
// MARK - CoreData functionality
    
    func fetchCategories() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
            
        }

        if let objects = self.fetchedResultsController.fetchedObjects {
            self.categories = objects + objects + objects
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
        let homeCell = self.collectionView?.cellForItem(at: IndexPath.init(row: self.middleCategoriesElementIndex, section: 0))
        homeCell?.tintColor = .cyan

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
  
    
// MARK - scrolling stuff
    
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
        
        UIView.transition(with: self.tableView,
                          duration: 0.2,
                          options: [.curveEaseInOut, .transitionCrossDissolve],
                          animations: {
            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
        })
        
        UIView.transition(with: self.categoryLabel,
                          duration: 0.2,
                          options: [.curveEaseInOut, .transitionCrossDissolve],
                          animations: {
                            self.categoryLabel.text = self.categories[self.middleCategoriesElementIndex].name
        })
    }
    
    
    func scrollTableView() {
        
        let currentOffset = self.tableView.contentOffset.y
        let offsetToNextRow = currentOffset.truncatingRemainder(dividingBy: self.tableViewRowHeight)
        
        if offsetToNextRow > self.tableViewRowHeight / 2 {
            let nextRowOffset = currentOffset - offsetToNextRow + self.tableViewRowHeight
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: nextRowOffset), animated: true)
        } else {
            let previousRowOffset = currentOffset - offsetToNextRow
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: previousRowOffset), animated: true)
        }
        
    }
    
    
    func scrollCollectionView() {
        
        var offsetToCenterMiddleItem = Constants.initialOffset + Constants.offsetPerCell * CGFloat(self.middleViewableItemIndex)
        let differenceWithActualLocation = offsetToCenterMiddleItem - self.collectionView!.contentOffset.x
        
        if differenceWithActualLocation > CGFloat(Constants.offsetPerCell / 2) {
            offsetToCenterMiddleItem -= CGFloat(Constants.offsetPerCell)
        } else if differenceWithActualLocation < CGFloat(0 - Constants.offsetPerCell / 2) {
            offsetToCenterMiddleItem -= CGFloat(Constants.offsetPerCell)
        }
        
        self.collectionView?.setContentOffset(CGPoint.init(x: offsetToCenterMiddleItem, y: 0), animated: true)
        
    }
    
    
}

