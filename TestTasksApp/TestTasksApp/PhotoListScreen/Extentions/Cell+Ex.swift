import UIKit

extension UITableViewCell {
    class var cellID: String {
         String(describing: self)
     }
}

extension UICollectionViewCell {
   class var cellID: String {
        String(describing: self)
    }
}
