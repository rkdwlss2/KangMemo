//
//  DatabaseHelper.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/23.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper{
    
    static let instance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImageinCoredata(at imgData: Data){
        let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as! Profile
        profile.img = imgData
        do{
            try context.save()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getAllImages() -> [Profile]{
        var arrProfile = [Profile]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do{
            arrProfile = try context.fetch(fetchRequest) as! [Profile]
        }catch let error{
            print(error.localizedDescription)
        }
        return arrProfile
    }
    
    
}
