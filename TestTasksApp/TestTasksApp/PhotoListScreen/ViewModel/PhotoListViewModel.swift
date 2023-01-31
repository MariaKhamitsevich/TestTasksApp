import UIKit

protocol PhotoListViewModelProtocol: AnyObject {
    var urls: [URL] { get }
    var onReceiveImage: ((UIImage, IndexPath) -> Void)? { get set }
    var onRecieveCallBack: (() -> Void)? { get set }
    var onRecieveFailureCallBack: ((String) -> Void)?  { get set }
    var reloadingCompletedCallBack: (() -> Void)?  { get set }
    
    func loadData()
    func getImageForDetailScreen(indexPath: IndexPath) -> PhotoModel
    func getImageSize(indexPath: IndexPath) -> (width: Int, height: Int)
    func reloadData()
    func willDisplayCell(at indexPath: IndexPath)
}

final class PhotoListViewModel: PhotoListViewModelProtocol {
    private let initialNumberOfPage: Int
    private var page: Int
    private let count: Int
    private let apiManager: ApiManagering
    private var photoList: [PhotoModel] = []
    private let cache = NSCache<NSNumber, UIImage>()

    var urls: [URL] {
        photoList.compactMap(\.urls.raw)
    }
    
    var onRecieveCallBack: (() -> Void)?
    var onRecieveFailureCallBack: ((String) -> Void)?
    var onReceiveImage: ((UIImage, IndexPath) -> Void)?
    var reloadingCompletedCallBack: (() -> Void)?
    
    init(page: Int, count: Int, apiManager: ApiManagering) {
        self.initialNumberOfPage = page
        self.page = page
        self.count = count
        self.apiManager = apiManager
    }
    
    func getImageForDetailScreen(indexPath: IndexPath) -> PhotoModel {
        photoList[indexPath.row]
    }
    
    func getImageSize(indexPath: IndexPath) -> (width: Int, height: Int) {
        let photo = photoList[indexPath.row]
        let width = photo.width
        let height = photo.height
        return (width: width, height: height)
    }

    func loadData() {
        apiManager.makeRequest(page: page, count: count) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photoListModel):
                self.photoList += photoListModel
                self.page += 1
                DispatchQueue.main.async {
                    self.onRecieveCallBack?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .requestFailed, .responseError:
                        self.onRecieveFailureCallBack?("")
                    default:
                        self.onRecieveFailureCallBack?("")
                    }
                }
            }
        }
    }

    func reloadData() {
        photoList.removeAll()
        page = initialNumberOfPage
        loadData()
        reloadingCompletedCallBack?()
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == photoList.count - 3 {
            loadData()
        }
    }
}
