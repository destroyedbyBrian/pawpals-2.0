import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var path: [AuthDestination] = []

    var body: some View {
        Group {
            if isAuthenticated {
                HomeView(onLogout: logout)
            } else {
                NavigationStack(path: $path) {
                    SignupView(
                        onShowLogin: showLogin,
                        onSignupCompleted: showAccountConfirmation(for:)
                    )
                    .navigationDestination(for: AuthDestination.self) { destination in
                        switch destination {
                        case .login:
                            LoginView(onLoginSuccess: handleLoginSuccess)
                        case .confirmAccount(let email):
                            AccountConfirmationView(email: email)
                        }
                    }
                }
            }
        }
    }

    private func showLogin() {
        path.append(.login)
    }

    private func showAccountConfirmation(for email: String) {
        path.append(.confirmAccount(email))
    }

    private func handleLoginSuccess() {
        path = []
        isAuthenticated = true
    }

    private func logout() {
        isAuthenticated = false
    }
}

private enum AuthDestination: Hashable {
    case login
    case confirmAccount(String)
}

#Preview {
    ContentView()
}
