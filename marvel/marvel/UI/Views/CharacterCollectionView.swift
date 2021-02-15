import UIKit

final class CharacterCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: CharacterCollectionViewLayout())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier
        )
        backgroundColor = .systemBackground
    }
}
