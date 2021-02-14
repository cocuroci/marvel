import UIKit
import Kingfisher

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CharacterCollectionViewCell.self)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
    
    func setupCell(character: Character) {
        imageView.kf.setImage(with: character.thumbnail?.url)
        nameLabel.text = character.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
}

extension CharacterCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(backgroundLabelView)
        backgroundLabelView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
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
