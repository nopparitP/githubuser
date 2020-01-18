
@testable import GithubUser
import XCTest

class GithubuserListPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var sut: GithubuserListPresenter!
  var viewControllerSpy: GithubuserListViewControllerSpy!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupGithubuserListPresenter()
  }

  override func tearDown() {
    sut = nil
    viewControllerSpy = nil
    super.tearDown()
  }

  // MARK: - Test setup

  func setupGithubuserListPresenter() {
    sut = GithubuserListPresenter()
    
    viewControllerSpy = GithubuserListViewControllerSpy()
    sut.viewController = viewControllerSpy
  }

  final class GithubuserListViewControllerSpy: GithubuserListViewControllerInterface {
    var displayGithubUsersCalled: Bool = false
    var displayFavouriteUsersCalled: Bool = false
    
    func displayGithubUsers(viewModel: GithubuserList.GetUser.ViewModel) {
      displayGithubUsersCalled = true
    }
    
    func displayFavouriteUsers(viewModel: GithubuserList.FavouriteUser.ViewModel) {
      displayFavouriteUsersCalled = true
    }
  }
  
  private func getUsers() -> GithubUser {
    return GithubUser.init(
    login: "",
    avatarURL: "",
    htmlURL: "",
    type: "",
    siteAdmin: true,
    isFavourite: false)
  }

  // MARK: - Tests

  func testPresentGithubUsersLoadingShouldCallDisplayGithubUsers() {
    // When
    sut.presentGithubUsersLoading()
    
    // Then
    XCTAssertTrue(viewControllerSpy.displayGithubUsersCalled)
  }
  
  func testPresentGithubUsersShouldCallDisplayGithubUsers() {
    // When
    sut.presentGithubUsers(response: GithubuserList.GetUser.Response(result: .success([getUsers()])))
    
    // Then
    XCTAssertTrue(viewControllerSpy.displayGithubUsersCalled)
  }
  
  func testPresentFavouriteUsersShouldCallDisplayGithubUsers() {
    // When
    sut.presentFavouriteUsers(response: GithubuserList.FavouriteUser.Response(result: [getUsers()]))
    
    // Then
    XCTAssertTrue(viewControllerSpy.displayFavouriteUsersCalled)
  }
}
