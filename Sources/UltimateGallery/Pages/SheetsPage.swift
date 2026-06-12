import SwiftUI
import Ultimate

struct SheetsPage: View {
    @State private var showSheet = false
    @State private var showGlassSheet = false
    @State private var showDialog = false
    @State private var showGlassDialog = false
    @State private var showToast = false

    var body: some View {
        GalleryPage(title: "Sheets & Toasts") {
            SpecimenSection(title: "Presenters") {
                VStack(alignment: .leading, spacing: USpacing.s3) {
                    UButton("Bottom sheet", variant: .soft, block: true) {
                        showSheet = true
                    }
                    UButton("Bottom sheet (glass)", variant: .soft, block: true) {
                        showGlassSheet = true
                    }
                    UButton("Dialog", variant: .soft, block: true) {
                        showDialog = true
                    }
                    UButton("Dialog (glass)", variant: .soft, block: true) {
                        showGlassDialog = true
                    }
                    UButton("Toast", variant: .soft, block: true) {
                        showToast = true
                    }
                }
            }

            SpecimenSection(title: "Sheet actions") {
                VStack(spacing: USpacing.s2) {
                    USheetAction(icon: "share-2", label: "Share", style: .soft) {}
                    USheetAction(icon: "pencil", label: "Rename", style: .plain) {}
                    USheetAction(icon: "trash-2", label: "Delete",
                                 style: .soft, destructive: true) {}
                }
            }
        }
        .uBottomSheet(isPresented: $showSheet, title: "Quick actions",
                      subtitle: "Choose what to do") {
            USheetAction(icon: "share-2", label: "Share") { showSheet = false }
            USheetAction(icon: "download", label: "Download") { showSheet = false }
            USheetAction(icon: "trash-2", label: "Delete",
                         destructive: true) { showSheet = false }
            USheetAction(icon: "pencil", label: "Rename", style: .plain) { showSheet = false }
            UButton("Done", variant: .primary, block: true) { showSheet = false }
                .padding(.top, USpacing.s2)
        }
        .uBottomSheet(isPresented: $showGlassSheet, title: "Glass sheet",
                      subtitle: "The page shimmers through", style: .glass) {
            USheetAction(icon: "share-2", label: "Share") { showGlassSheet = false }
            USheetAction(icon: "download", label: "Download") { showGlassSheet = false }
            UButton("Done", variant: .primary, block: true) { showGlassSheet = false }
                .padding(.top, USpacing.s2)
        }
        .uDialog(isPresented: $showDialog,
                 title: "Delete item?",
                 message: "This action cannot be undone.",
                 primaryLabel: "Delete",
                 primaryAction: {},
                 cancelLabel: "Cancel")
        .uDialog(isPresented: $showGlassDialog,
                 title: "Glass dialog",
                 message: "Same dialog, frosted chrome.",
                 primaryLabel: "OK",
                 primaryAction: {},
                 style: .glass)
        .uToast(isPresented: $showToast, icon: "check", message: "Saved")
    }
}
