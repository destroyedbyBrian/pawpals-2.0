import Foundation
import Supabase

protocol AuthServicing {
    func signUp(email: String, password: String) async throws
    func verifySignupOTP(email: String, token: String) async throws
    func resendSignupOTP(email: String) async throws
}

struct SupabaseAuthService: AuthServicing {
    func signUp(email: String, password: String) async throws {
        let client = try SupabaseClientFactory.makeClient()
        _ = try await client.auth.signUp(email: email, password: password)
    }

    func verifySignupOTP(email: String, token: String) async throws {
        let client = try SupabaseClientFactory.makeClient()
        _ = try await client.auth.verifyOTP(
            email: email,
            token: token,
            type: .signup
        )
    }

    func resendSignupOTP(email: String) async throws {
        let client = try SupabaseClientFactory.makeClient()
        try await client.auth.resend(
            email: email,
            type: .signup
        )
    }
}

enum SupabaseClientFactory {
    static func makeClient() throws -> SupabaseClient {
        guard
            let url = URL(string: SupabaseConfig.url),
            !SupabaseConfig.url.isEmpty,
            !SupabaseConfig.url.contains("YOUR_SUPABASE")
        else {
            throw SupabaseConfigurationError.missingURL
        }

        guard
            !SupabaseConfig.anonKey.isEmpty,
            !SupabaseConfig.anonKey.contains("YOUR_SUPABASE")
        else {
            throw SupabaseConfigurationError.missingAnonKey
        }

        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: SupabaseConfig.anonKey
        )
    }
}

enum SupabaseConfigurationError: LocalizedError {
    case missingURL
    case missingAnonKey

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "Set `SupabaseConfig.url` to your Supabase project URL."
        case .missingAnonKey:
            return "Set `SupabaseConfig.anonKey` to your Supabase anon key."
        }
    }
}
