import UIKit

final class FeedbackStatusView: UIView {
    private let action: () -> Void
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
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tentar novamente", for: .normal)
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textLabel, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    init(text: String, imageName: String, action: @escaping () -> Void) {
        self.text = text
        self.imageName = imageName
        self.action = action
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func touchButton() {
        action()
    }
}

extension FeedbackStatusView: ViewConfiguration {
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
