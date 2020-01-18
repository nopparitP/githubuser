import UIKit
import KRProgressHUD

protocol GithubuserListViewControllerInterface: class {
  func displayGithubUsers(viewModel: GithubuserList.GetUser.ViewModel)
  func displayFavouriteUsers(viewModel: GithubuserList.FavouriteUser.ViewModel)
}

class GithubuserListViewController: UIViewController, GithubuserListViewControllerInterface {
  var interactor: GithubuserListInteractorInterface!
  var router: GithubuserListRouter!
  @IBOutlet private weak var userTableView: UITableView!
  var githubUsers: [GithubUserViewModel] = []
  
  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: GithubuserListViewController) {
    let router = GithubuserListRouter()
    router.viewController = viewController

    let presenter = GithubuserListPresenter()
    presenter.viewController = viewController

    let interactor = GithubuserListInteractor()
    interactor.presenter = presenter
    interactor.worker = GithubuserListWorker(store: GithubuserListStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    userTableView.delegate = self
    userTableView.dataSource = self
    userTableView.register(UINib(nibName: Nib.userCell.rawValue, bundle: nil), forCellReuseIdentifier: Cell.userCell.rawValue)
    userTableView.tableFooterView = UIView()
    getGithubUsers()
  }

  // MARK: - Event handling

  func getGithubUsers() {
    let request = GithubuserList.GetUser.Request(type: .refresh)
    interactor.getGithubUsers(request: request)
  }

  // MARK: - Display logic

  func displayGithubUsers(viewModel: GithubuserList.GetUser.ViewModel) {
    // NOTE: Display the result from the Presenter
    
    switch viewModel.content {
      case .loading:
        KRProgressHUD.show()
      case .success(let users):
        githubUsers = users
        userTableView.reloadData()
        KRProgressHUD.dismiss()
      case .failure:
        KRProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  }
  
  func displayFavouriteUsers(viewModel: GithubuserList.FavouriteUser.ViewModel) {
    githubUsers = viewModel.content
    userTableView.reloadData()
  }
}

extension GithubuserListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.githubUsers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userCell.rawValue) as? GithubUserCell else {
      return UITableViewCell()
    }
    let GithubUserViewModel = githubUsers[indexPath.row]
    cell.selectionStyle = .none
    cell.indexPath = indexPath
    cell.delegate = self
    cell.updateUI(githubUser: GithubUserViewModel)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    router.navigateToDetail(githubUser: githubUsers[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastElement = self.githubUsers.count - 1
    if indexPath.row == lastElement {
        let request = GithubuserList.GetUser.Request(type: .loadmore)
        interactor.getGithubUsers(request: request)
    }
  }
}

extension GithubuserListViewController: TabButtonsDelegate {
  func favouriteTapped(at indexPath: IndexPath) {
    interactor.favouriteUsers(request: GithubuserList.FavouriteUser.Request(index: indexPath.row))
  }
}
