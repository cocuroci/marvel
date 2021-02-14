import UIKit

protocol DetailDisplaying: AnyObject {
    func displayName(_ name: String?)
    func displayImage(url: URL?)
    func displayDescription(_ description: String?)
    func displayStarImage(_ image: UIImage?)
}

private extension DetailViewController.Layout {
    enum Size {
        static let imageHeightMultiplier: CGFloat = 0.33
    }
    
    enum Space {
        static let marginText: CGFloat = 16
    }
}

final class DetailViewController: UIViewController, ViewConfiguration {
    fileprivate enum Layout { }
    
    private let interactor: DetailInteracting
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        return button
    }()
    
    init(interactor: DetailInteracting) {
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
        interactor.showCharacter()
    }
    
    func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionView)
        
        descriptionView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Layout.Size.imageHeightMultiplier),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: Layout.Space.marginText),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -Layout.Space.marginText),
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: Layout.Space.marginText),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -Layout.Space.marginText)
        ])
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: starButton)
    }
    
    @objc private func touchButton() {
        interactor.didFavoriteCharacter()
    }
}

extension DetailViewController: DetailDisplaying {
    func displayName(_ name: String?) {
        title = name
    }
    
    func displayImage(url: URL?) {
        imageView.kf.setImage(with: url)
    }
    
    func displayDescription(_ description: String?) {
        descriptionLabel.text = description
    }
    
    func displayStarImage(_ image: UIImage?) {
        starButton.setImage(image, for: .normal)
    }
}
