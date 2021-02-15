import UIKit

extension CharacterCollectionViewLayout.Layout {
    enum Size {
        static let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let screenWidth = UIScreen.main.bounds.width
        static let cellWidth = ((screenWidth - sectionInset.left - sectionInset.right) / 2) - (sectionInset.left / 2)
        static let cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
}

final class CharacterCollectionViewLayout: UICollectionViewFlowLayout {
    fileprivate enum Layout { }
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        sectionInset = Layout.Size.sectionInset
        itemSize = Layout.Size.cellSize
    }
}
