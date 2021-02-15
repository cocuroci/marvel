import UIKit

protocol BookmarksDisplaying: AnyObject {
    func displayCharacters(_ characters: [Character])
    func displayEmptyView(text: String, imageName: String)
    func clearList()
}

final class BookmarksViewController: UIViewController, ViewConfiguration {
    private let interactor: BookmarksInteracting
    private var characters: [Character] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = CharacterCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(interactor: BookmarksInteracting) {
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
        view.backgroundColor = .systemBackground
        title = "Favoritos"
    }
}

private extension BookmarksViewController {
    func createEdgeConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension BookmarksViewController: BookmarksDisplaying {
    func displayCharacters(_ characters: [Character]) {
        self.characters = characters
        collectionView.reloadData()
    }
    
    func displayEmptyView(text: String, imageName: String) {
        let emptyView = EmptyView(text: text, imageName: imageName)
        view.addSubview(emptyView)
        createEdgeConstraints(view: emptyView)
    }
    
    func clearList() {
        characters = []
        collectionView.reloadData()
    }
}

extension BookmarksViewController: UICollectionViewDataSource {
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

extension BookmarksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectCharacter(with: indexPath)
    }
}

extension BookmarksViewController: CharacterCollectionViewCellDelegate {
    func didTouchStarButton(character: Character?) {
        interactor.removeFromBookmarks(character: character)
    }
}
