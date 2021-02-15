import XCTest
@testable import marvel

private final class DetailViewControllerSpy: DetailDisplaying {
    // MARK: - displayName
    private(set) var displayNameCount = 0
    private(set) var name: String?
    
    func displayName(_ name: String?) {
        displayNameCount += 1
        self.name = name
    }
    
    // MARK: - displayImage
    private(set) var displayImageCount = 0
    private(set) var imageURL: URL?
    
    func displayImage(url: URL?) {
        displayImageCount += 1
        imageURL = url
    }
    
    // MARK: - displayDescription
    private(set) var displayDescriptionCount = 0
    private(set) var description: String?
    
    func displayDescription(_ description: String?) {
        displayDescriptionCount += 1
        self.description = description
    }
    
    // MARK: - displayStarImage
    private(set) var displayStarImageCount = 0
    private(set) var starImage: UIImage?
    
    func displayStarImage(_ image: UIImage?) {
        displayStarImageCount += 1
        starImage = image
    }
}

final class DetailPresenterTests: XCTestCase {
    private let viewControllerSpy = DetailViewControllerSpy()
    
    private lazy var sut: DetailPresenting = {
        let presenter = DetailPresenter()
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func testPresentName_ShouldDisplayName() {
        sut.presentName("name")
        
        XCTAssertEqual(viewControllerSpy.displayNameCount, 1)
        XCTAssertEqual(viewControllerSpy.name, "name")
    }
    
    func testPresentImage_ShouldDisplayImage() {
        sut.presentImage(url: URL(string: "http://i.image.br/123.jpg"))
        
        XCTAssertEqual(viewControllerSpy.displayImageCount, 1)
        XCTAssertEqual(viewControllerSpy.imageURL, URL(string: "http://i.image.br/123.jpg"))
    }
    
    func testPresentDescription_ShouldDisplayDescription() {
        sut.presentDescription("description")
        
        XCTAssertEqual(viewControllerSpy.displayDescriptionCount, 1)
        XCTAssertEqual(viewControllerSpy.description, "description")
    }
    
    func testPresentCharacterIsFavorite_ShouldDisplayStarFill() {
        sut.presentCharacterIsFavorite()
        
        XCTAssertEqual(viewControllerSpy.displayStarImageCount, 1)
        XCTAssertEqual(viewControllerSpy.starImage, UIImage(systemName: "star.fill"))
    }
    
    func testPresentCharacterIsFavorite_ShouldDisplayStar() {
        sut.presentCharacterIsNotFavorite()
        
        XCTAssertEqual(viewControllerSpy.displayStarImageCount, 1)
        XCTAssertEqual(viewControllerSpy.starImage, UIImage(systemName: "star"))
    }
}
