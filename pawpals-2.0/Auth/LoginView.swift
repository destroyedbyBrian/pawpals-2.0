import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss

    let onLoginSuccess: () -> Void

    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""

    private var validationMessage: String? {
        LoginValidator.validationMessage(
            email: email,
            password: password
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.90, blue: 0.75),
                    Color(red: 0.84, green: 0.76, blue: 0.61),
                    Color(red: 0.48, green: 0.42, blue: 0.29)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LoginHeader()
                    loginForm
                    LoginFooter(onShowSignup: { dismiss() })
                }
                .padding(24)
            }
        }
        .navigationTitle("Log In")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Log In", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var loginForm: some View {
        VStack(alignment: .leading, spacing: 18) {
            AuthTextField(
                title: "Email",
                text: $email,
                textContentType: .username,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )

            AuthSecureField(
                title: "Password",
                text: $password,
                textContentType: .password
            )

            if let validationMessage {
                AuthValidationMessage(text: validationMessage)
            }

            Button(action: login) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(viewModel.isLoading ? "Logging In..." : "Log In")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(.white)
            }
            .disabled(viewModel.isLoading)

            Text("Use the same email and password you registered with in Supabase Auth.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func login() {
        Task {
            let success = await viewModel.login(
                email: email,
                password: password
            )

            if success {
                password = ""
                onLoginSuccess()
            }
        }
    }
}

private struct LoginHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome back")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            Text("Log in to PawPals")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Enter your email and password to continue.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.82))
        }
        .padding(.top, 24)
    }
}

private struct LoginFooter: View {
    let onShowSignup: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text("Need an account?")

            Button("Create one", action: onShowSignup)
                .fontWeight(.semibold)
                .buttonStyle(.plain)
        }
        .font(.footnote)
        .foregroundStyle(.white.opacity(0.88))
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        LoginView(onLoginSuccess: { })
    }
}
