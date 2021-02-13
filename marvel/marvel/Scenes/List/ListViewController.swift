import UIKit

protocol ListDisplaying: AnyObject {
    func displayCharacters(_ characters: [Character])
    func displayLoader()
    func displayNoInternetView()
    func hideLoader()
}

final class ListViewController: UIViewController, ViewConfiguration {
    private let interactor: ListInteracting
    private var characters: [Character] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var loaderView = LoaderView()
    
    private lazy var noInternetConnectionView = NoInternetConnectionView { [weak self] in
        self?.interactor.tryAgain()
    }
    
    init(interactor: ListInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.fetchList()
    }
    
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = "Personagens"
    }
}

private extension ListViewController {
    func createConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension ListViewController: ListDisplaying {
    func displayCharacters(_ characters: [Character]) {
        self.characters = characters
        tableView.reloadData()
    }
    
    func displayLoader() {
        view.addSubview(loaderView)
        createConstraints(view: loaderView)
    }
    
    func hideLoader() {
        loaderView.removeFromSuperview()
    }
    
    func displayNoInternetView() {
        view.addSubview(noInternetConnectionView)
        createConstraints(view: noInternetConnectionView)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }
}
