import SwiftUI

struct AccountConfirmationView: View {
    @StateObject private var viewModel: AccountConfirmationViewModel

    init(email: String) {
        _viewModel = StateObject(wrappedValue: AccountConfirmationViewModel(email: email))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.89, blue: 0.75),
                    Color(red: 0.91, green: 0.70, blue: 0.58),
                    Color(red: 0.74, green: 0.42, blue: 0.38)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    form
                }
                .padding(24)
            }
        }
        .navigationTitle("Confirm Account")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Email Verification", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("One more step")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            Text("Enter the code from your email")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("We sent a 6-digit verification code to \(viewModel.maskedEmail).")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.82))
        }
        .padding(.top, 24)
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Verification Code")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                TextField("123456", text: $viewModel.otpCode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(Color.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .onChange(of: viewModel.otpCode) { _, newValue in
                        let digits = newValue.filter(\.isNumber)
                        if digits != newValue || digits.count > 6 {
                            viewModel.otpCode = String(digits.prefix(6))
                        }
                    }
            }

            if let validationMessage = viewModel.validationMessage {
                Text(validationMessage)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(Color(red: 0.55, green: 0.07, blue: 0.14))
            }

            Button {
                Task {
                    _ = await viewModel.verifyCode()
                }
            } label: {
                HStack {
                    if viewModel.isVerifying {
                        ProgressView()
                            .tint(.white)
                    }

                    Text(viewModel.isVerifying ? "Verifying..." : "Verify Email")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(.white)
            }
            .disabled(viewModel.isVerifying || viewModel.isResending)

            Button {
                Task {
                    await viewModel.resendCode()
                }
            } label: {
                HStack {
                    if viewModel.isResending {
                        ProgressView()
                    }

                    Text(viewModel.isResending ? "Sending..." : "Resend Code")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .foregroundStyle(.black.opacity(0.78))
            }
            .disabled(viewModel.isVerifying || viewModel.isResending)

            if let lastResendAt = viewModel.lastResendAt {
                Text("Last sent \(lastResendAt.formatted(date: .omitted, time: .shortened)).")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.82))
            }
        }
        .padding(22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        AccountConfirmationView(email: "hello@example.com")
    }
}
