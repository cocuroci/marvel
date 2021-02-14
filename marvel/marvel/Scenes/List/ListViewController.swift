import UIKit

protocol ListDisplaying: AnyObject {
    func displayCharacters(_ characters: [Character])
    func displayLoader()
    func displayFeedbackView(text: String, imageName: String)
    func removeFeedbackView()
    func displayEmptyView(text: String, imageName: String)
    func hideLoader()
}

private extension ListViewController.Layout {
    enum Size {
        static let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let screenWidth = UIScreen.main.bounds.width
        static let cellWidth = ((screenWidth - sectionInset.left - sectionInset.right) / 2) - (sectionInset.left / 2)
        static let cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
}

final class ListViewController: UIViewController, ViewConfiguration {
    fileprivate enum Layout { }
    
    private let interactor: ListInteracting
    private var characters: [Character] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Layout.Size.sectionInset
        layout.itemSize = Layout.Size.cellSize
        return layout
    }()
    
    private lazy var loaderView = LoaderView()
    
    private var currentFeedbackView: UIView?
    
    init(interactor: ListInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.fetchList()
    }
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = "Personagens"
    }
}

private extension ListViewController {
    func createConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension ListViewController: ListDisplaying {
    func displayCharacters(_ characters: [Character]) {
        self.characters = characters
        collectionView.reloadData()
    }
    
    func displayLoader() {
        view.addSubview(loaderView)
        createConstraints(view: loaderView)
    }
    
    func hideLoader() {
        loaderView.removeFromSuperview()
    }
    
    func displayFeedbackView(text: String, imageName: String) {
        let feedbackView = FeedbackStatusView(text: text, imageName: imageName) { [weak self] in
            self?.interactor.tryAgain()
        }
        
        view.addSubview(feedbackView)
        createConstraints(view: feedbackView)
        currentFeedbackView = feedbackView
    }
    
    func removeFeedbackView() {
        currentFeedbackView?.removeFromSuperview()
    }
    
    func displayEmptyView(text: String, imageName: String) {
        let emptyView = EmptyView(text: text, imageName: imageName)
        view.addSubview(emptyView)
        createConstraints(view: emptyView)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CharacterCollectionViewCell
        
        cell.setupCell(character: characters[indexPath.row])
        return cell
    }
}
