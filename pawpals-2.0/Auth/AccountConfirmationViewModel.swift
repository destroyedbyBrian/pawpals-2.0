import Foundation
import Combine

@MainActor
final class AccountConfirmationViewModel: ObservableObject {
    @Published var otpCode = ""
    @Published var isVerifying = false
    @Published var isResending = false
    @Published var alertMessage = ""
    @Published var isShowingAlert = false
    @Published private(set) var lastResendAt: Date?

    let email: String

    private let authService: AuthServicing

    init(
        email: String,
        authService: AuthServicing = SupabaseAuthService()
    ) {
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        self.authService = authService
    }

    var validationMessage: String? {
        AccountConfirmationValidator.validationMessage(
            email: email,
            otpCode: otpCode
        )
    }

    var maskedEmail: String {
        AccountConfirmationValidator.maskedEmail(email)
    }

    func verifyCode() async -> Bool {
        guard let code = AccountConfirmationValidator.normalizedOTP(otpCode) else {
            alertMessage = validationMessage ?? "Enter the verification code from your email."
            isShowingAlert = true
            return false
        }

        isVerifying = true
        defer { isVerifying = false }

        do {
            try await authService.verifySignupOTP(email: email, token: code)
            alertMessage = "Your email has been verified. You can continue into the app."
            isShowingAlert = true
            return true
        } catch {
            alertMessage = error.localizedDescription
            isShowingAlert = true
            return false
        }
    }

    func resendCode() async {
        guard AccountConfirmationValidator.emailValidationMessage(email) == nil else {
            alertMessage = AccountConfirmationValidator.emailValidationMessage(email) ?? "Enter a valid email."
            isShowingAlert = true
            return
        }

        isResending = true
        defer { isResending = false }

        do {
            try await authService.resendSignupOTP(email: email)
            lastResendAt = Date()
            alertMessage = "A new verification email has been sent."
            isShowingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowingAlert = true
        }
    }
}

enum AccountConfirmationValidator {
    static func validationMessage(email: String, otpCode: String) -> String? {
        if let emailMessage = emailValidationMessage(email) {
            return emailMessage
        }

        let digits = otpCode.filter(\.isNumber)

        if digits.isEmpty {
            return "Enter the 6-digit code sent to your email."
        }

        if digits.count != 6 {
            return "The verification code must be 6 digits."
        }

        return nil
    }

    static func emailValidationMessage(_ email: String) -> String? {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if normalizedEmail.isEmpty {
            return "A valid email is required for verification."
        }

        if !normalizedEmail.contains("@") {
            return "Enter a valid email address."
        }

        return nil
    }

    static func normalizedOTP(_ otpCode: String) -> String? {
        let digits = otpCode.filter(\.isNumber)
        return digits.count == 6 ? digits : nil
    }

    static func maskedEmail(_ email: String) -> String {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let atIndex = normalizedEmail.firstIndex(of: "@") else {
            return normalizedEmail
        }

        let localPart = String(normalizedEmail[..<atIndex])
        let domain = String(normalizedEmail[atIndex...])

        guard localPart.count > 2 else {
            return localPart.prefix(1) + "•••" + domain
        }

        return "\(localPart.prefix(2))•••\(domain)"
    }
}
