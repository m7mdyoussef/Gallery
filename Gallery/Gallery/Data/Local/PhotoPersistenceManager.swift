
import UIKit
import CoreData


class PhotoPersistenceManager{
    
    var context:NSManagedObjectContext!
    static let shared = PhotoPersistenceManager()
    
    private init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func savePhotoData(photos:[PhotoModel], completion: @escaping (Result<Bool,NSError>) -> Void){
        let entity = NSEntityDescription.entity(forEntityName: GalleryCachingConstants.photoData, in: context)
        for photo in photos {
            let photoObj = NSManagedObject(entity: entity!, insertInto: context)
            photoObj.setValue(photo.author, forKey: GalleryCachingConstants.author)
            photoObj.setValue(photo.id, forKey: GalleryCachingConstants.id)
            photoObj.setValue(photo.download_url, forKey: GalleryCachingConstants.download_url)
            photoObj.setValue(photo.url, forKey: GalleryCachingConstants.url)
            photoObj.setValue(photo.width, forKey: GalleryCachingConstants.width)
            photoObj.setValue(photo.height, forKey: GalleryCachingConstants.height)
        }
        do{
            try context.save()
            completion(.success(true))
        } catch let error as NSError{
            completion(.failure(error))
            return
        }
    }
        
    func getPhotos(completion: @escaping ([PhotoModel]?) -> Void){
        var photosData = [PhotoModel]()
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: GalleryCachingConstants.photoData)

        do {
            let photos = try context.fetch(fetchReq)
            for photo in photos{
                let author = photo.value(forKey: GalleryCachingConstants.author) as! String
                  let id = photo.value(forKey: GalleryCachingConstants.id) as! String
                  let download_url = photo.value(forKey: GalleryCachingConstants.download_url) as! String
                  let url = photo.value(forKey: GalleryCachingConstants.url) as! String
                  let width = photo.value(forKey: GalleryCachingConstants.width) as! Int
                  let height = photo.value(forKey: GalleryCachingConstants.height) as! Int
                   photosData.append(PhotoModel(id: id, author: author, width: width , height: height, download_url: download_url, url: url))
               }
            if(photosData.isEmpty){
                completion(nil)
            }else{
                completion(photosData)
            }
            
        } catch {
            completion(nil)
        }
    }
    
    func deleteAllPhotos() {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: GalleryCachingConstants.photoData)
        fetchReq.returnsObjectsAsFaults = false
        do {
            let photos = try context.fetch(fetchReq)
            for photo in photos {
                guard let photoData = photo as? NSManagedObject else {continue}
                context.delete(photoData)
            }
        } catch let error {
            print("joe, DB error \(error)")
        }
    }
}
