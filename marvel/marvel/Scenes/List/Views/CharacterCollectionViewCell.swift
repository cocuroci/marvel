import UIKit
import Kingfisher

protocol CharacterCollectionViewCellDelegate: AnyObject {
    func didTouchStarButton(character: Character?)
}

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CharacterCollectionViewCell.self)
    
    weak var delegate: CharacterCollectionViewCellDelegate?
    var character: Character?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var starImage = UIImage(systemName: "star")
    private lazy var starSelectedImage = UIImage(systemName: "star.fill")
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        button.tintColor = .systemYellow
        return button
    }()
    
    private lazy var backgroundLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(character: Character, hideFavoriteButton: Bool = false) {
        imageView.kf.setImage(with: character.thumbnail?.url)
        nameLabel.text = character.name
        favoriteButton.isHidden = hideFavoriteButton
        character.isFavorite == true ?
            favoriteButton.setImage(starSelectedImage, for: .normal) : favoriteButton.setImage(starImage, for: .normal)
        self.character = character
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        character = nil
    }
    
    @objc
    private func touchButton() {
        delegate?.didTouchStarButton(character: character)
    }
}

extension CharacterCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(backgroundLabelView)
        backgroundLabelView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backgroundLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: backgroundLabelView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundLabelView.trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: backgroundLabelView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundLabelView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureViews() {
        backgroundColor = .secondarySystemBackground
    }
}
