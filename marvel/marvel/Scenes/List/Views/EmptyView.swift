import UIKit

final class EmptyView: UIView {
    private let imageName: String
    private let text: String
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = text
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(containerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
    }
}
