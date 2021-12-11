
import Foundation
import Alamofire

enum DataResponseError: Error {
    case network
    case decoding
    case wrongURL
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        case .wrongURL:
            return "An error occurred beacuse wrong URL"
        }
    }
}

struct NetworkService {
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
        AF.cancelAllRequests()
    }
}
