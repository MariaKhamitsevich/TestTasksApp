import UIKit

final class PhotoListFactory {
    static func makePhotoListScreen() -> UIViewController {
        PhotoListViewController(viewModel: PhotoListViewModel(page: 1, count: 20, apiManager: ApiManager(networkManager: NetworkManager(session: URLSession.shared))))
    }
}
