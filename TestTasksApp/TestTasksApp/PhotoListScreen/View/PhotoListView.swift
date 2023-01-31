import UIKit
import SnapKit


final class PhotoListViewController: UIViewController {
    private lazy var collectionView = makeColectionView()
    private let viewModel: PhotoListViewModelProtocol
    private lazy var pullToRefreshController = UIRefreshControl()
    private var numberOfLastCell: Int = 0
    private lazy var dataSource = configureDataSource()
    
    init(viewModel: PhotoListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupNavigationController()
        setupRefreshControll()
        updateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK: - setup UI
private extension PhotoListViewController {
    func setupUI() {
        view.backgroundColor = .white
        addAllSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    func addAllSubviews() {
        view.addSubview(collectionView)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: PhotoListCollectionViewCell.cellID)
        collectionView.refreshControl = pullToRefreshController
        if let layout = collectionView.collectionViewLayout as? PhotoListCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    func setupViewModel() {
        viewModel.loadData()
        viewModel.onRecieveCallBack = reloadNewCells
    }
    
    func setupNavigationController() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupRefreshControll() {
        viewModel.reloadingCompletedCallBack = pullToRefreshController.endRefreshing
        pullToRefreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc func pullToRefresh() {
        numberOfLastCell = 0
        viewModel.reloadData()
    }
    
    func reloadNewCells() {
        updateSnapshot()
    }
}

//MARK: - make subviews
private extension PhotoListViewController {
    func makeColectionView() -> UICollectionView {
        let flow = PhotoListCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
}

//MARK: - make constraints
private extension PhotoListViewController {
    func setupConstraints() {
        collectionView.snp.updateConstraints { make in
            make.top.equalTo(view.snp.top).offset(71)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
}

//MARK: - UICollectionViewDelegate
extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: 24, bottom: .zero, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoModel = viewModel.getImageForDetailScreen(indexPath: indexPath)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension PhotoListViewController  {
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, URL> {
        let dataSource = UICollectionViewDiffableDataSource<Section, URL>(collectionView: collectionView) { (collectionView, indexPath, url) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.cellID, for: indexPath) as? PhotoListCollectionViewCell
            cell?.setImage(imageURL: url)
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, URL>()
        snapshot.appendSections([.all])
        print(viewModel.urls)
        snapshot.appendItems(viewModel.urls, toSection: .all)
     
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PhotoListViewController: PhotoListLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let (width, height) = viewModel.getImageSize(indexPath: indexPath)
        let floatWidth =  CGFloat(width)
        let floatHeight = CGFloat(height)
        let parametr = floatWidth / floatHeight
        let cellWidth = UIScreen.main.bounds.width / 2 - 16
        let cellHeight = cellWidth / parametr
        return cellHeight
    }
}
