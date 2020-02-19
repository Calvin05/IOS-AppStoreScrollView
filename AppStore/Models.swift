//
//  Models.swift
//  AppStore
//
//  Created by Cường Nguyễn on 2019-03-18.
//  Copyright © 2019 Cường Nguyễn. All rights reserved.
//

import UIKit

class AppObject: Decodable {
    var bannerCategory: BannerCategory?
    var categories: [AppCategory]?
}

class BannerCategory: AppCategory {
    
}

class App: Decodable {
    var Id: Int?
    var Name: String?
    var Category: String?
    var Price: Double?
    var ImageName: String?
    var Screenshots: [String]?
    var description: String?
    var appInformation: [AppInfo]?
}
class AppInfo: Decodable {
    var Name: String?
    var Value: String?
}

class AppCategory: Decodable {
    var name: String?
    var apps: [App]?
    var type: String?
    
    static func fetchFeatureApps(handler: @escaping (AppObject) -> Void) {
        let url = "https://api.letsbuildthatapp.com/appstore/featured"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let tarea = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                // couldn't get data from server
                return
            }
            do {
                let json: AppObject = try JSONDecoder().decode(AppObject.self, from: data!)
                handler(json)
            } catch _ {
                // do something when error occcur
            }
        }
        tarea.resume()
    }
    
//    static func sampleAppCategories() -> [AppCategory] {
//        let bestAppCategory = AppCategory()
//        bestAppCategory.name = "Best New Apps"
//
//        var apps = [App]()
//
//        //logic
//
//        let redApps = App()
//        redApps.name = "Cute eyes in red"
//        redApps.imageName = "frozen"
//        redApps.category = "Entertainment"
//        redApps.price = NSNumber(floatLiteral: 3.99)
//
//        apps.append(redApps)
//        bestAppCategory.apps = apps
//
//        let bestNewGameCategory = AppCategory()
//        bestNewGameCategory.name = "Best New Games"
//
//        var bestNewGameApps = [App]()
//
//        let telepaintApp = App()
//        telepaintApp.name = "Telepaint"
//        telepaintApp.category = "Game"
//        telepaintApp.imageName = "telepaint"
//        telepaintApp.price = NSNumber(floatLiteral: 2.99)
//
//        bestNewGameApps.append(telepaintApp)
//        bestNewGameCategory.apps = bestNewGameApps
//        return [bestAppCategory, bestNewGameCategory]
//    }
}
