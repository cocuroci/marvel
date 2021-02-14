import UIKit

protocol DetailDisplaying: AnyObject {
    func displayCharacter(_ character: Character)
}

final class DetailViewController: UIViewController, ViewConfiguration {
    private let interactor: DetailInteracting
    
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
        
    }
    
    func setupConstraints() {
        
    }
    
    func configureViews() {
        
    }
}

extension DetailViewController: DetailDisplaying {
    func displayCharacter(_ character: Character) {
        
    }
}
