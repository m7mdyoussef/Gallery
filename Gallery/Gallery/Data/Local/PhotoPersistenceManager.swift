
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
    
    func getPhotos() -> [PhotoModel]?{
        var photosData = [PhotoModel]()
        
        do {
            let fetchReq = NSFetchRequest<NSManagedObject>(entityName: GalleryCachingConstants.photoData)
            let photos = try context.fetch(fetchReq)
            photos.forEach { photo in
                if let author = photo.value(forKey: GalleryCachingConstants.author),
                   let id = photo.value(forKey: GalleryCachingConstants.id),
                   let download_url = photo.value(forKey: GalleryCachingConstants.download_url),
                   let url = photo.value(forKey: GalleryCachingConstants.url),
                   let width = photo.value(forKey: GalleryCachingConstants.width),
                   let height = photo.value(forKey: GalleryCachingConstants.height){
                    photosData.append(PhotoModel(id: id as! String, author: author as! String, width: width as! Int, height: height as! Int, download_url: download_url as! String, url: url as! String))
                }
            }
        } catch {
            return nil
        }
        
        if photosData.isEmpty {
            return nil
        } else {
            return photosData
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
