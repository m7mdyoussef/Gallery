
import UIKit
import CoreData


class UserPersistenceManager{
    
    var context:NSManagedObjectContext!
    static let shared = UserPersistenceManager()
    
    private init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveUserData(user:UserDataModel, completion: @escaping (Bool) -> Void){
        let entity = NSEntityDescription.entity(forEntityName: GalleryCachingConstants.userData, in: context)
        let userObj = NSManagedObject(entity: entity!, insertInto: context)
        
        userObj.setValue(user.mobileNumber, forKey: GalleryCachingConstants.userName)
        userObj.setValue(user.password, forKey: GalleryCachingConstants.password)
        
        do{
            try context.save()
        } catch {
            completion(false)
        }
        completion(true)
    }
    
    func getUserData(userName: String, completion: @escaping ([UserDataModel]?) -> Void){
        var usersData = [UserDataModel]()
        do {
            let fetchReq = NSFetchRequest<NSManagedObject>(entityName: GalleryCachingConstants.userData)
            let users = try context.fetch(fetchReq)
            users.forEach { user in
                if let cachedUserName = user.value(forKey: GalleryCachingConstants.userName),
                   let cachedpassword = user.value(forKey: GalleryCachingConstants.password){
                    usersData.append(UserDataModel(mobileNumber: cachedUserName as! String, password: cachedpassword as! String))
                }
            }
        } catch {
            completion(nil)
        }
        
        if usersData.isEmpty {
            completion(nil)
        } else {
            completion(usersData)
        }
        
    }
    
}

