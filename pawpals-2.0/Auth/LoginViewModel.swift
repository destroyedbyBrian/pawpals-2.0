import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var isShowingAlert = false

    private let authService: AuthServicing

    init(authService: AuthServicing = SupabaseAuthService()) {
        self.authService = authService
    }

    func login(email: String, password: String) async -> Bool {
        guard LoginValidator.validationMessage(email: email, password: password) == nil else {
            alertMessage = LoginValidator.validationMessage(email: email, password: password) ?? "Check your login details and try again."
            isShowingAlert = true
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.signIn(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            return true
        } catch {
            alertMessage = error.localizedDescription
            isShowingAlert = true
            return false
        }
    }
}

enum LoginValidator {
    static func validationMessage(email: String, password: String) -> String? {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if normalizedEmail.isEmpty || password.isEmpty {
            return "Fill in your email and password."
        }

        if !normalizedEmail.contains("@") {
            return "Enter a valid email address."
        }

        return nil
    }
}
