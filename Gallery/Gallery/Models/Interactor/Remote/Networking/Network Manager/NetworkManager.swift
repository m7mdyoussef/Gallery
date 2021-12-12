
import Foundation

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private init() {}
    
  //  private let networkService = NetworkService()
        
    func fetchData(page: Int, limit: Int, completion: @escaping (Result<[PhotoModel]?, DataResponseError>) -> Void) {
        
        let queryItems = [URLQueryItem(name: Constant.page, value: String(page)), URLQueryItem(name: Constant.limit, value: String(limit))]
        var urlComps = URLComponents(string: Constant.baseURL)
        urlComps?.queryItems = queryItems
        if let url = urlComps?.url{
            NetworkService.sharedInstance.fetchData(url: url) { (result) in
                switch result {
                case .failure(let err):
                    completion(.failure(err))
                case .success(let data):
                    guard let decodedResponse = try? JSONDecoder().decode([PhotoModel].self, from: data) else {
                        completion(Result.failure(DataResponseError.decoding))
                        return
                    }
                    completion(.success(decodedResponse))
                }
            }
        } else {
            completion(.failure(DataResponseError.wrongURL))
        }
    }
    
    func cancelAllRequests(){
        NetworkService.sharedInstance.cancelAllRequests()
    }
}
