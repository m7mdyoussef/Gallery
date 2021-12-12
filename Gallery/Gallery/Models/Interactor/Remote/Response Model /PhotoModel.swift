
import Foundation
import Foundation

struct PhotoModel: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
    let url: String
}
