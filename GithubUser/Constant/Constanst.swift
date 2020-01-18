import Foundation

enum API: String {
  case users = "https://api.github.com/users"
}

enum Cell: String {
  case userCell = "githubUserCell"
}

enum Nib: String {
  case userCell = "GithubUserCell"
}

enum Image: String {
  case placeholder = "default_image"
}

enum Credential: String {
  case username = ""
  case token = ""
}
