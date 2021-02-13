import UIKit

final class LoaderView: UIView {
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.startAnimating()
        return loader
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Carregando..."
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loader, textLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoaderView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(containerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
    }
}
