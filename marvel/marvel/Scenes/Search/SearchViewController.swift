import UIKit
import Kingfisher

protocol SearchDisplaying: AnyObject {
    func displayCharacters(_ characters: [Character])
    func displayEmptyView(text: String, imageName: String)
    func displayLoader()
    func displayFeedbackView(text: String, imageName: String, hideActionButton: Bool)
    func hideLoader()
    func resetView()
}

final class SearchViewController: UIViewController, ViewConfiguration {
    private let interactor: SearchInteracting
    private var characters = [Character]()
    
    private lazy var collectionView: CharacterCollectionView = {
        let collectionView = CharacterCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var loaderView = LoaderView()
    
    private var statusView: UIView?
    
    init(interactor: SearchInteracting) {
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
    }
    
    func buildViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        createEdgeConstraints(view: collectionView)
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
    }
}

private extension SearchViewController {
    func createEdgeConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension SearchViewController: SearchDisplaying {
    func displayCharacters(_ characters: [Character]) {
        self.characters = characters
        collectionView.reloadData()
        statusView?.removeFromSuperview()
    }
    
    func displayEmptyView(text: String, imageName: String) {
        statusView?.removeFromSuperview()
        let emptyView = EmptyView(text: text, imageName: imageName)
        view.addSubview(emptyView)
        createEdgeConstraints(view: emptyView)
        statusView = emptyView
    }
    
    func displayLoader() {
        view.addSubview(loaderView)
        createEdgeConstraints(view: loaderView)
    }

    func displayFeedbackView(text: String, imageName: String, hideActionButton: Bool) {
        statusView?.removeFromSuperview()
        let feedbackView = FeedbackStatusView(text: text, imageName: imageName, hideActionButton: true)
        view.addSubview(feedbackView)
        createEdgeConstraints(view: feedbackView)
        statusView = feedbackView
    }
    
    func hideLoader() {
        loaderView.removeFromSuperview()
    }
    
    func resetView() {
        self.characters = []
        collectionView.reloadData()
        statusView?.removeFromSuperview()
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        interactor.didDismissSearch()
    }
}

extension SearchViewController: UICollectionViewDataSource {
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
        
        cell.setupCell(character: characters[indexPath.row], hideFavoriteButton: true)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectCharacter(with: indexPath)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(with: searchBar.text)
    }
}
