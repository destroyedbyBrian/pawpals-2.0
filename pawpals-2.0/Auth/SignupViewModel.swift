import Foundation
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var isShowingAlert = false

    private let authService: AuthServicing

    init(authService: AuthServicing = SupabaseAuthService()) {
        self.authService = authService
    }

    func signUp(email: String, password: String, confirmPassword: String) async -> Bool {
        guard SignupValidator.validationMessage(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        ) == nil else {
            let message = SignupValidator.validationMessage(
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
            alertMessage = message ?? "Check your details and try again."
            isShowingAlert = true
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authService.signUp(
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

enum SignupValidator {
    static func validationMessage(email: String, password: String, confirmPassword: String) -> String? {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if normalizedEmail.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return "Fill in your email, password, and password confirmation."
        }

        if !normalizedEmail.contains("@") {
            return "Enter a valid email address."
        }

        if password.count < 6 {
            return "Use at least 6 characters for your password."
        }

        if password != confirmPassword {
            return "Passwords do not match."
        }

        return nil
    }
}
