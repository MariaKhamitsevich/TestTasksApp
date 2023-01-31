import UIKit

extension UIImageView {
    func setImage(url: URL, completion: (() -> Void)? = nil) {
        let imageManager = DataManager.shared
        imageManager.fetchData(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                    completion?()
                }
            case .failure(_):
                let image = UIImage(named: "unknownImage")
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
