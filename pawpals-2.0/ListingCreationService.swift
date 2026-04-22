import Foundation
import Supabase

protocol ListingCreationServicing {
    func createListing(_ draft: ListingSubmissionDraft) async throws -> ListingRecord
}

struct SupabaseListingCreationService: ListingCreationServicing {
    func createListing(_ draft: ListingSubmissionDraft) async throws -> ListingRecord {
        let client = try SupabaseClientFactory.makeClient()

        do {
            _ = try await client.auth.session
        } catch {
            throw ListingCreationError.notAuthenticated
        }

        let listing: ListingRecord = try await client
            .from("listings")
            .insert(ListingInsertRequest(from: draft))
            .select()
            .single()
            .execute()
            .value

        return listing
    }
}

struct ListingSubmissionDraft {
    let petBreed: String
    let serviceType: String
    let startTime: Date
    let durationMinutes: Int
    let price: Double
}

private struct ListingInsertRequest: Encodable {
    let petBreed: String
    let serviceType: String
    let startTime: String
    let duration: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case petBreed = "pet_breed"
        case serviceType = "service_type"
        case startTime = "start_time"
        case duration
        case price
    }

    init(from draft: ListingSubmissionDraft) {
        petBreed = draft.petBreed
        serviceType = draft.serviceType
        startTime = ListingDateFormatter.iso8601.string(from: draft.startTime)
        duration = "\(draft.durationMinutes) minutes"
        price = draft.price
    }
}

struct ListingRecord: Decodable {
    let status: String

    enum CodingKeys: String, CodingKey {
        case status
    }
}

enum ListingCreationError: LocalizedError {
    case notAuthenticated

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Log in before creating a listing."
        }
    }
}

enum ListingDateFormatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
