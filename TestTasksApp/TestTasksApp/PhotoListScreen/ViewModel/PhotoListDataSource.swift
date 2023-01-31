import UIKit

enum Section: Hashable {
    case all
}

enum Item: Hashable {
    
}

struct SectionData {
    var key: Section
    var values: [Item]
}

final class PhotoListDataSource: UICollectionViewDiffableDataSource<Section, Item> {
    func reload(_ data: [SectionData], animated: Bool = true) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.cellID, for: indexPath) as? PhotoListCollectionViewCell
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        for item in data {
            snapshot.appendSections([item.key])
            snapshot.appendItems(item.values, toSection: item.key)
        }
        apply(snapshot, animatingDifferences: animated)
    }
}
