import SwiftUI
import Ultimate

struct InputsPage: View {
    @State private var empty = ""
    @State private var filled = "Jane Appleseed"
    @State private var labelled = ""
    @State private var withIcon = ""
    @State private var onCard = ""
    @State private var searchEmpty = ""
    @State private var searchFilled = "Coffee"

    var body: some View {
        GalleryPage(title: "Inputs") {
            SpecimenSection(title: "Text field") {
                VStack(spacing: USpacing.s4) {
                    Specimen(label: "empty") {
                        UInput(text: $empty, placeholder: "Placeholder")
                    }
                    Specimen(label: "pre-filled") {
                        UInput(text: $filled, placeholder: "Name")
                    }
                    Specimen(label: "with label") {
                        UInput(text: $labelled, label: "Full name", placeholder: "Jane Appleseed")
                    }
                    Specimen(label: "with icon") {
                        UInput(text: $withIcon, placeholder: "Email", icon: "mail")
                    }
                    Specimen(label: "onCard") {
                        UCard {
                            UInput(text: $onCard, label: "Card number",
                                   placeholder: "0000 0000 0000 0000", icon: "credit-card",
                                   onCard: true)
                        }
                    }
                }
            }

            SpecimenSection(title: "Search bar") {
                VStack(spacing: USpacing.s4) {
                    Specimen(label: "empty") { USearchBar(text: $searchEmpty) }
                    Specimen(label: "filled") { USearchBar(text: $searchFilled) }
                }
            }
        }
    }
}
