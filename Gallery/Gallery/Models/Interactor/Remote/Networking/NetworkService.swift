
import Foundation
import Alamofire

enum DataResponseError: Error {
    case network
    case decoding
    case wrongURL
    
    var reason: String {
        switch self {
        case .network:
            return Constant.networkingError
        case .decoding:
            return Constant.decodingError
        case .wrongURL:
            return Constant.wrongURLError
      
        }
    }
}

class NetworkService {
    
    static let sharedInstance = NetworkService()
    
    private init() {}
    
    func fetchData(url: URL, completion: @escaping (Result<Data, DataResponseError>) -> Void) {
        AF.request(url).responseData { (data) in
            guard let httpResponse = data.response,
                  httpResponse.statusCode == 200,
                  let data = data.data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            completion(.success(data))
        }
    }
    
    func cancelAllRequests(){
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
}
