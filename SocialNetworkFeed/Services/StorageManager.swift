//
//  StorageManager.swift
//  SocialNetworkFeed
//
//  Created by Danila Umnov on 05.03.2025.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SocialNetworkFeed")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    func createPost(withId id: Int, userId: Int, title: String, body: String, completion: (Post) -> Void) {
        let post = Post(context: context)
        post.id = Int64(id)
        post.userId = Int64(userId)
        post.title = title
        post.body = body
        saveContext()
        completion(post)
    }
    
    func fetchData(complition: (Result<[Post], NSError>) -> Void) {
        let fetchRequest = Post.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            complition(.success(posts))
        } catch {
            complition(.failure(error as NSError))
        }
    }
    
    func update(_ post: Post, newName: String) {
        post.title = newName
        saveContext()
    }
    
    func delete(_ post: Post) {
        context.delete(post)
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
