import XCTest
@testable import marvel

private final class DetailPresenterSpy: DetailPresenting {
    var viewController: DetailDisplaying?
    
    // MARK: - presentName
    private(set) var presentNameCount = 0
    private(set) var presentedName: String?
    
    func presentName(_ name: String?) {
        presentNameCount += 1
        presentedName = name
    }
    
    // MARK: - presentImage
    private(set) var presentImageCount = 0
    private(set) var presentedImage: URL?
    
    func presentImage(url: URL?) {
        presentImageCount += 1
        presentedImage = url
    }
    
    // MARK: - presentDescription
    private(set) var presentDescriptionCount = 0
    private(set) var presentedDescription: String?
    
    func presentDescription(_ description: String?) {
        presentDescriptionCount += 1
        presentedDescription = description
    }
    
    // MARK: - presentCharacterIsFavorite
    private(set) var presentCharacterIsFavoriteCount = 0
    
    func presentCharacterIsFavorite() {
        presentCharacterIsFavoriteCount += 1
    }
    
    // MARK: - presentCharacterIsNotFavorite
    private(set) var presentCharacterIsNotFavoriteCount = 0
    
    func presentCharacterIsNotFavorite() {
        presentCharacterIsNotFavoriteCount += 1
    }
}

final class DetailInteractorTests: XCTestCase {
    private let presenterSpy = DetailPresenterSpy()
    private let bookmarksSpy = BookmarksSpy()
    
    func setupSut(characterIsFavorite: Bool = false) -> DetailInteracting {
        let thumbnail = CharacterImage(path: "http://i.img.br/123", extension: "jpg")
        let character = Character(id: 1, name: "name", description: "description", thumbnail: thumbnail, isFavorite: characterIsFavorite)
        let interactor = DetailInteractor(character: character, presenter: presenterSpy, bookmarks: bookmarksSpy)
        return interactor
    }
    
    func testShowCharacter_WhenCharacterIsNotFavorited_ShouldPresentCharacterData() {
        let sut = setupSut()
        
        sut.showCharacter()
        
        XCTAssertEqual(presenterSpy.presentNameCount, 1)
        XCTAssertEqual(presenterSpy.presentedName, "name")
        XCTAssertEqual(presenterSpy.presentDescriptionCount, 1)
        XCTAssertEqual(presenterSpy.presentedDescription, "description")
        XCTAssertEqual(presenterSpy.presentImageCount, 1)
        XCTAssertEqual(presenterSpy.presentedImage, URL(string: "http://i.img.br/123.jpg"))
        XCTAssertEqual(presenterSpy.presentCharacterIsNotFavoriteCount, 1)
    }
    
    func testShowCharacter_WhenCharacterIsFavorited_ShouldPresentCharacterData() {
        let sut = setupSut(characterIsFavorite: true)
        
        sut.showCharacter()
        
        XCTAssertEqual(presenterSpy.presentNameCount, 1)
        XCTAssertEqual(presenterSpy.presentedName, "name")
        XCTAssertEqual(presenterSpy.presentDescriptionCount, 1)
        XCTAssertEqual(presenterSpy.presentedDescription, "description")
        XCTAssertEqual(presenterSpy.presentImageCount, 1)
        XCTAssertEqual(presenterSpy.presentedImage, URL(string: "http://i.img.br/123.jpg"))
        XCTAssertEqual(presenterSpy.presentCharacterIsFavoriteCount, 1)
    }
    
    func testDidFavoriteCharacter_WhenCharacterIsNotFavorite_ShouldSaveCharacterInBookmark() {
        let sut = setupSut()
        
        sut.didFavoriteCharacter()
        
        XCTAssertEqual(bookmarksSpy.saveCount, 1)
        XCTAssertEqual(bookmarksSpy.savedCharacter?.isFavorite, true)
        XCTAssertEqual(presenterSpy.presentCharacterIsFavoriteCount, 1)
    }
    
    func testDidFavoriteCharacter_WhenCharacterIsFavorite_ShouldSaveCharacterInBookmark() {
        let sut = setupSut(characterIsFavorite: true)
        
        sut.didFavoriteCharacter()
        
        XCTAssertEqual(bookmarksSpy.removeCount, 1)
        XCTAssertEqual(bookmarksSpy.removedCharacter?.isFavorite, false)
        XCTAssertEqual(presenterSpy.presentCharacterIsNotFavoriteCount, 1)
    }
}
