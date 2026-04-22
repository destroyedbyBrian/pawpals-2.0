import SwiftUI

struct AuthTextField: View {
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

struct AuthSecureField: View {
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

struct AuthValidationMessage: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote.weight(.medium))
            .foregroundStyle(Color(red: 0.55, green: 0.07, blue: 0.14))
    }
}
