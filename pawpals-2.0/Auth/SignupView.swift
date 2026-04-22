import SwiftUI

struct SignupView: View {
    let onShowLogin: () -> Void
    let onSignupCompleted: (String) -> Void

    @StateObject private var viewModel = SignupViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    private var validationMessage: String? {
        SignupValidator.validationMessage(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.84, blue: 0.73),
                    Color(red: 0.95, green: 0.64, blue: 0.55),
                    Color(red: 0.78, green: 0.35, blue: 0.38)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SignupHeader()
                    signupForm
                    SignupFooter(onShowLogin: onShowLogin)
                }
                .padding(24)
            }
        }
        .alert("Sign Up", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var signupForm: some View {
        VStack(alignment: .leading, spacing: 18) {
            AuthTextField(
                title: "Email",
                text: $email,
                textContentType: .emailAddress,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )

            AuthSecureField(
                title: "Password",
                text: $password,
                textContentType: .newPassword
            )

            AuthSecureField(
                title: "Confirm Password",
                text: $confirmPassword,
                textContentType: .newPassword
            )

            if let validationMessage {
                AuthValidationMessage(text: validationMessage)
            }

            Button(action: createAccount) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(viewModel.isLoading ? "Creating Account..." : "Create Account")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(.white)
            }
            .disabled(viewModel.isLoading)

            Text("You’ll need to set your Supabase URL and anon key in `SupabaseConfig.swift` before this can create real accounts.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func createAccount() {
        Task {
            let success = await viewModel.signUp(
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )

            guard success else { return }

            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            password = ""
            confirmPassword = ""
            onSignupCompleted(trimmedEmail)
        }
    }
}

private struct SignupHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PawPals")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            Text("Create your pet parent account")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Sign up with email and password using Supabase Auth.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.top, 36)
    }
}

private struct SignupFooter: View {
    let onShowLogin: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text("Already have an account?")

            Button("Log in", action: onShowLogin)
                .fontWeight(.semibold)
                .buttonStyle(.plain)
        }
        .font(.footnote)
        .foregroundStyle(.white.opacity(0.86))
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        SignupView(
            onShowLogin: { },
            onSignupCompleted: { _ in }
        )
    }
}
