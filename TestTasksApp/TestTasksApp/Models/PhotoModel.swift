import Foundation

struct PhotoModel: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: PhotoURL
}

struct PhotoURL: Codable {
    let raw: URL?
}

