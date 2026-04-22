import SwiftUI
import Combine

struct HomeView: View {
    let onLogout: () -> Void

    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeDashboardView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AppTab.home)

            NavigationStack {
                ScheduleView()
            }
            .tabItem {
                Label("Schedule", systemImage: "calendar")
            }
            .tag(AppTab.schedule)

            NavigationStack {
                PetsView()
            }
            .tabItem {
                Label("Pets", systemImage: "pawprint.fill")
            }
            .tag(AppTab.pets)

            NavigationStack {
                ProfileView(onLogout: onLogout)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(AppTab.profile)
        }
        .tint(Color(red: 0.55, green: 0.34, blue: 0.18))
    }
}

private enum AppTab {
    case home
    case schedule
    case pets
    case profile
}

private struct HomeDashboardView: View {
    @State private var isPresentingListingCreator = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.93, blue: 0.84),
                    Color(red: 0.89, green: 0.74, blue: 0.60),
                    Color(red: 0.67, green: 0.53, blue: 0.39)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroCard
                    quickActions
                    tipsCard
                }
                .padding(24)
            }
        }
        .navigationTitle("Home")
        .navigationDestination(isPresented: $isPresentingListingCreator) {
            ListingCreationView()
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("PawPals")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            Text("Your pet care home base")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("You’re signed in. From here, users can check upcoming care tasks, recent activity, and shortcuts into the rest of the app.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.84))

            Button {
                isPresentingListingCreator = true
            } label: {
                Label("Create Listing", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundStyle(Color.black.opacity(0.82))
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(Color.black.opacity(0.72), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Today")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                HomeStatCard(
                    title: "Walks",
                    value: "2",
                    detail: "Morning and evening reminders"
                )
                HomeStatCard(
                    title: "Meals",
                    value: "3",
                    detail: "Next feeding in 2 hours"
                )
                HomeStatCard(
                    title: "Medications",
                    value: "1",
                    detail: "Heartworm dose scheduled"
                )
                HomeStatCard(
                    title: "Notes",
                    value: "5",
                    detail: "Recent updates from caregivers"
                )
            }
        }
    }

    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What’s next")
                .font(.title3.weight(.bold))

            Text("Check in on your pet’s routine, review reminders, and jump into the tasks that matter today.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct ScheduleView: View {
    var body: some View {
        FeaturePlaceholderView(
            title: "Schedule",
            subtitle: "Keep walks, meals, grooming, and medication on one timeline.",
            accent: Color(red: 0.82, green: 0.58, blue: 0.43),
            items: [
                "7:00 AM walk with Milo",
                "12:30 PM lunch feeding",
                "6:00 PM heartworm reminder"
            ]
        )
        .navigationTitle("Schedule")
    }
}

private struct PetsView: View {
    var body: some View {
        FeaturePlaceholderView(
            title: "Pets",
            subtitle: "Profiles, care notes, and health details can live here per pet.",
            accent: Color(red: 0.73, green: 0.48, blue: 0.36),
            items: [
                "Milo · Golden Retriever · 4 years old",
                "Luna · Tabby Cat · 2 years old",
                "Add vaccination and allergy records"
            ]
        )
        .navigationTitle("Pets")
    }
}

private struct ProfileView: View {
    let onLogout: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.92, blue: 0.86),
                    Color(red: 0.89, green: 0.79, blue: 0.69),
                    Color(red: 0.75, green: 0.62, blue: 0.51)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pet Parent")
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    Text("Account settings, preferences, and sign-out controls can expand from this tab.")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 14) {
                    ProfileRow(label: "Email", value: "Signed-in account")
                    ProfileRow(label: "Plan", value: "Starter")
                    ProfileRow(label: "Notifications", value: "Daily reminders enabled")
                }
                .padding(22)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))

                Button("Log Out", action: onLogout)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.82), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Profile")
    }
}

private struct FeaturePlaceholderView: View {
    let title: String
    let subtitle: String
    let accent: Color
    let items: [String]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    accent.opacity(0.22),
                    Color.white,
                    accent.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))

                        Text(subtitle)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(accent)
                                    .frame(width: 10, height: 10)
                                    .padding(.top, 6)

                                Text(item)
                                    .foregroundStyle(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        }
                    }
                }
                .padding(24)
            }
        }
    }
}

private struct ProfileRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}

private struct HomeStatCard: View {
    let title: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text(detail)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(18)
        .background(Color.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct ListingCreationView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ListingCreationViewModel()
    @State private var listing = ListingDraft()

    var body: some View {
        Form {
            Section("Listing Details") {
                TextField("Pet breed", text: $listing.petBreed)

                Picker("Service Type", selection: $listing.serviceType) {
                    ForEach(ListingServiceType.allCases) { serviceType in
                        Text(serviceType.label).tag(serviceType)
                    }
                }
            }

            Section("Timing") {
                DatePicker("Start Time", selection: $listing.startTime)

                Stepper(value: $listing.durationMinutes, in: 30...720, step: 30) {
                    LabeledContent("Duration", value: "\(listing.durationMinutes) minutes")
                }
            }

            Section("Pricing") {
                TextField("Price", text: $listing.price)
                    .keyboardType(.decimalPad)
            }

            Section {
                Button(action: submitListing) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                        }

                        Text(viewModel.isLoading ? "Creating Listing..." : "Start Listing Creation")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("New Listing")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Listing Creation", isPresented: $viewModel.isShowingAlert) {
            Button(viewModel.didCreateListing ? "Done" : "OK") {
                if viewModel.didCreateListing {
                    listing = ListingDraft()
                    dismiss()
                }
                viewModel.clearAlertState()
            }

            if viewModel.didCreateListing {
                Button("Create Another") {
                    listing = ListingDraft()
                    viewModel.clearAlertState()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private func submitListing() {
        Task {
            let success = await viewModel.createListing(
                draft: ListingDraftSubmissionInput(
                    petBreed: listing.petBreed.trimmingCharacters(in: .whitespacesAndNewlines),
                    serviceType: listing.serviceType.rawValue,
                    startTime: listing.startTime,
                    durationMinutes: listing.durationMinutes,
                    priceText: listing.price
                )
            )

            if success {
                listing = ListingDraft()
            }
        }
    }
}

private struct ListingDraft {
    var petBreed = ""
    var serviceType: ListingServiceType = .walk
    var startTime = Date()
    var durationMinutes = 60
    var price = ""
}

private enum ListingServiceType: String, CaseIterable, Identifiable {
    case walk
    case sit

    var id: String { rawValue }

    var label: String {
        switch self {
        case .walk:
            return "Walk"
        case .sit:
            return "Sit"
        }
    }
}

@MainActor
private final class ListingCreationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage = ""
    @Published var isShowingAlert = false
    @Published var didCreateListing = false

    private let listingService: ListingCreationServicing

    init(listingService: ListingCreationServicing = SupabaseListingCreationService()) {
        self.listingService = listingService
    }

    func createListing(draft: ListingDraftSubmissionInput) async -> Bool {
        guard let validatedDraft = draft.validatedDraft else {
            alertMessage = draft.validationMessage ?? "Check your listing details and try again."
            didCreateListing = false
            isShowingAlert = true
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let listing = try await listingService.createListing(validatedDraft)
            alertMessage = """
            Your listing was created and is now \(listing.status).
            """
            didCreateListing = true
            isShowingAlert = true
            return true
        } catch {
            alertMessage = error.localizedDescription
            didCreateListing = false
            isShowingAlert = true
            return false
        }
    }

    func clearAlertState() {
        alertMessage = ""
        didCreateListing = false
        isShowingAlert = false
    }
}

private struct ListingDraftSubmissionInput {
    let petBreed: String
    let serviceType: String
    let startTime: Date
    let durationMinutes: Int
    let priceText: String

    var validationMessage: String? {
        if petBreed.isEmpty {
            return "Pet breed is required."
        }

        if Double(priceText) == nil {
            return "Price must be a valid number."
        }

        return nil
    }

    var validatedDraft: ListingSubmissionDraft? {
        guard validationMessage == nil, let price = Double(priceText) else {
            return nil
        }

        return ListingSubmissionDraft(
            petBreed: petBreed,
            serviceType: serviceType,
            startTime: startTime,
            durationMinutes: durationMinutes,
            price: price
        )
    }
}

#Preview {
    HomeView(onLogout: { })
}
