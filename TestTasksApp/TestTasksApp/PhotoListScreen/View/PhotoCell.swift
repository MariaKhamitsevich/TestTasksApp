import UIKit
import SnapKit
import SDWebImage

protocol PhotoListCollectionViewCellProtocol {
    func setImage(imageURL: URL)
}

final class PhotoListCollectionViewCell: UICollectionViewCell, PhotoListCollectionViewCellProtocol {
   private lazy var mainImageView = makeMainImage()
    
    override func prepareForReuse() {
        mainImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(imageURL: URL) {
        mainImageView.sd_setImage(with: imageURL)
    }
}

//MARK: - setup UI
private extension PhotoListCollectionViewCell {
    func setupCell() {
        addAllSubviews()
        setupConstraints()
    }
    
    func addAllSubviews() {
        contentView.addSubview(mainImageView)
    }
}

//MARK: - make subviews
private extension PhotoListCollectionViewCell {
    func makeMainImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }
}

//MARK: - make constraints
private extension PhotoListCollectionViewCell {
    func setupConstraints() {
        mainImageView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
