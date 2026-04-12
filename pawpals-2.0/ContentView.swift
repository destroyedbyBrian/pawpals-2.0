import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SignupViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var pendingConfirmationEmail: String?
    @State private var isShowingConfirmation = false

    var body: some View {
        NavigationStack {
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
                        header
                        form
                        footer
                    }
                    .padding(24)
                }
            }
            .navigationDestination(isPresented: $isShowingConfirmation) {
                if let pendingConfirmationEmail {
                    AccountConfirmationView(email: pendingConfirmationEmail)
                }
            }
        }
        .alert("Sign Up", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var header: some View {
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

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            SignupTextField(
                title: "Email",
                text: $email,
                textContentType: .emailAddress,
                keyboardType: .emailAddress,
                autocapitalization: .never
            )

            SignupSecureField(
                title: "Password",
                text: $password,
                textContentType: .newPassword
            )

            SignupSecureField(
                title: "Confirm Password",
                text: $confirmPassword,
                textContentType: .newPassword
            )

            if let validationMessage = validationMessage {
                Text(validationMessage)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(Color(red: 0.55, green: 0.07, blue: 0.14))
            }

            Button {
                Task {
                    let success = await viewModel.signUp(
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword
                    )

                    if success {
                        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        password = ""
                        confirmPassword = ""
                        pendingConfirmationEmail = trimmedEmail
                        isShowingConfirmation = true
                    }
                }
            } label: {
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

    private var footer: some View {
        HStack(spacing: 6) {
            Text("Already have an account?")
            Text("Log in")
                .fontWeight(.semibold)
        }
        .font(.footnote)
        .foregroundStyle(.white.opacity(0.86))
        .padding(.bottom, 24)
    }

    private var validationMessage: String? {
        SignupValidator.validationMessage(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
}

private struct SignupTextField: View {
    let title: String
    @Binding var text: String
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField(title, text: $text)
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled()
                .padding()
                .background(Color.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

private struct SignupSecureField: View {
    let title: String
    @Binding var text: String
    let textContentType: UITextContentType?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            SecureField(title, text: $text)
                .textContentType(textContentType)
                .padding()
                .background(Color.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

#Preview {
    ContentView()
}
