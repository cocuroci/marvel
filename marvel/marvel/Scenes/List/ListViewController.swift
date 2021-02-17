import UIKit

protocol ListDisplaying: AnyObject {
    func displayCharacters(_ characters: [Character])
    func displayLoader()
    func displayFeedbackView(text: String, imageName: String)
    func removeFeedbackView()
    func displayEmptyView(text: String, imageName: String)
    func hideLoader()
}

final class ListViewController: UIViewController, ViewConfiguration {
    private let interactor: ListInteracting
    private var characters: [Character] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = CharacterCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.addTarget(self, action: #selector(touchStarButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchViewController = SearchFactory.make(delegate: self)
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.showsSearchResultsController = true
        searchController.searchBar.delegate = searchViewController
        searchController.delegate = searchViewController
        return searchController
    }()
    
    private lazy var loaderView = LoaderView()
    
    private var currentFeedbackView: UIView?
    
    init(interactor: ListInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
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
        createEdgeConstraints(view: collectionView)
    }
    
    func configureViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: starButton)
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
        title = "Personagens"
        definesPresentationContext = true
    }
}

private extension ListViewController {
    @objc
    private func touchStarButton() {
        interactor.showBookmarks()
    }
    
    func createEdgeConstraints(view: UIView) {
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
        createEdgeConstraints(view: loaderView)
    }
    
    func hideLoader() {
        loaderView.removeFromSuperview()
    }
    
    func displayFeedbackView(text: String, imageName: String) {
        let feedbackView = FeedbackStatusView(text: text, imageName: imageName) { [weak self] in
            self?.interactor.tryAgain()
        }
        
        view.addSubview(feedbackView)
        createEdgeConstraints(view: feedbackView)
        currentFeedbackView = feedbackView
    }
    
    func removeFeedbackView() {
        currentFeedbackView?.removeFromSuperview()
    }
    
    func displayEmptyView(text: String, imageName: String) {
        let emptyView = EmptyView(text: text, imageName: imageName)
        view.addSubview(emptyView)
        createEdgeConstraints(view: emptyView)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(character: characters[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectCharacter(with: indexPath)
    }
}

extension ListViewController: CharacterCollectionViewCellDelegate {
    func didTouchStarButton(character: Character?) {
        interactor.didFavoriteCharacter(character: character)
    }
}

extension ListViewController: SearchDelegate {
    func didSelectedCharacter(_ character: Character) {
        interactor.didSelectCharacter(with: character)
    }
}
