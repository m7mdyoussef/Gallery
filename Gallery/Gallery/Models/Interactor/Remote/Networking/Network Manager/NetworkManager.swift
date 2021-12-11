
import Foundation

struct NetworkManager {
    
    private let networkService = NetworkService()
    
    func downloadImage(url: String, completion: @escaping (Result<Data, DataResponseError>) -> Void) {
        if let url = URL(string: url) {
            networkService.fetchData(url: url) { (result) in
                completion(result)
            }
        } else {
            completion(.failure(DataResponseError.wrongURL))
        }
    }
    
    
    func fetchData(url: String, page: Int, completion: @escaping (Result<[PhotoModel], DataResponseError>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "limit", value: "10")]
        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = queryItems
        if let url = urlComps?.url{
            networkService.fetchData(url: url) { (result) in
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
        networkService.cancelAllRequests()
    }
}

//https://picsum.photos/v2/list?page=99&limit=10
