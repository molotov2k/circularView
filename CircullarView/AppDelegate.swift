//
//  AppDelegate.swift
//  Youplus
//
//  Created by Astarta on 10/12/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let userDefaults = UserDefaults()
        if !userDefaults.bool(forKey: Constants.loaded) {
            self.generateTestData()
            userDefaults.set(true, forKey: Constants.loaded)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.makeKeyAndVisible()
        self.window?.rootViewController = RootViewController()
        
        return true
    }
    
    
    func generateTestData() {
        let coreDataHelper = CoreDataHelper()
        let context = coreDataHelper.persistentContainer.viewContext
        
        let food = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        food.name = "Food"
        food.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "food128")!)!)
        food.index = 0
        
        let beverages = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        beverages.name = "Beverages"
        beverages.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "drink128")!)!)
        beverages.index = 1
        
        let tech = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        tech.name = "Tech"
        tech.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "gadget128")!)!)
        tech.index = 2
        
        let fitness = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        fitness.name = "Fitness"
        fitness.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "fitness128")!)!)
        fitness.index = 4
        
        let home = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        home.name = "Home"
        home.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "home128")!)!)
        home.index = 3
        
        let other = NSEntityDescription.insertNewObject(forEntityName: Constants.typeEntity, into: context) as! Type
        other.name = "Other"
        other.image = NSData(data: UIImagePNGRepresentation(UIImage(named: "other128")!)!)
        other.index = 5
        
        let greatFood = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        greatFood.name = "Great Food"
        greatFood.originalPrice = 1337
        greatFood.latitude = 0.0
        greatFood.longitude = 0.0
        greatFood.type = food
        food.addToItems(greatFood)
        
        let awesomeBeverage = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        awesomeBeverage.name = "Awesome Beverage"
        awesomeBeverage.originalPrice = 31337
        awesomeBeverage.latitude = 0.0
        awesomeBeverage.longitude = 1.0
        awesomeBeverage.type = beverages
        beverages.addToItems(awesomeBeverage)
        
        let neatGadget = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        neatGadget.name = "Neat Gadget"
        neatGadget.originalPrice = 404
        neatGadget.latitude = 2.0
        neatGadget.longitude = 2.0
        neatGadget.type = tech
        tech.addToItems(neatGadget)
        
        let quickSession = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        quickSession.name = "Quick session"
        quickSession.originalPrice = 42
        quickSession.latitude = 3.0
        quickSession.longitude = 3.0
        quickSession.type = fitness
        fitness.addToItems(quickSession)
        
        let sweetHome = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        sweetHome.name = "Home Sweet Home"
        sweetHome.originalPrice = 1000000
        sweetHome.latitude = 4.0
        sweetHome.longitude = 4.0
        sweetHome.type = home
        home.addToItems(sweetHome)
        
        let someBS = NSEntityDescription.insertNewObject(forEntityName: Constants.itemEntity, into: context) as! Item
        someBS.name = "Where am I?"
        someBS.originalPrice = 0
        someBS.latitude = 5.0
        someBS.longitude = 5.0
        someBS.type = other
        other.addToItems(someBS)
        
        
        do {
            try context.save()
            print("Test data generated successfully!")
        } catch {
            fatalError("Failure to generate test data: \(error)")
        }
    }

    
}

