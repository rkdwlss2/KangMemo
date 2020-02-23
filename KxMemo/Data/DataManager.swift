//
//  DataManager.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/17.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import Foundation
import CoreData

class DataManger{
    static let shared = DataManger()
    private init() {
        //Singleton
    }

    var mainContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchMemo(){
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request)
        }catch{
            print(error)
        }
    }
    
    
    
    func addNewMemo(_ memo: String?,_ UIImage: Array<Data>){
        let newMemo = Memo(context: mainContext)
        
        
//        newMemo.imag = UIImage[0] as Data
//        newMemo.imag = UIImage[0] as Data
//        for i in 0..<UIImage.count{
        for i in 0..<UIImage.count{
            newMemo.content = memo
            newMemo.insertDate = Date()
           newMemo.imag = UIImage[i]
            memoList.insert(newMemo, at:0)
            saveContext()
        }
            
//        }
        //        newMemo.imag =image
 //       memoList.insert(newMemo, at: 0)
        
        
        print(newMemo.imag ?? UIImage)
    }
    
    func deleteMemo(_ memo: Memo?){
        if let memo = memo{
            mainContext.delete(memo)
            saveContext()
        }
        
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "KxMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func getAllImages() -> [Memo]{
        var arrProfile = [Memo]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        do{
            arrProfile = try mainContext.fetch(fetchRequest) as! [Memo]
        }catch let error{
            print(error.localizedDescription)
        }
        return arrProfile
    }

}
