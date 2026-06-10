import SwiftUI
import Ultimate

struct ControlsPage: View {
    @State private var switchA = true
    @State private var switchB = false
    @State private var checkA = true
    @State private var checkB = false
    @State private var radioSelection = 0
    @State private var seg2 = 0
    @State private var seg3 = 1
    @State private var stepperH = 2
    @State private var stepperV = 0
    @State private var slider = 0.5

    var body: some View {
        GalleryPage(title: "Controls") {
            SpecimenSection(title: "Switch") {
                HStack(spacing: USpacing.s5) {
                    USwitch(isOn: $switchA)
                    USwitch(isOn: $switchB)
                    USwitch(isOn: .constant(true)).disabled(true)
                    USwitch(isOn: .constant(false)).disabled(true)
                }
            }

            SpecimenSection(title: "Checkbox") {
                HStack(spacing: USpacing.s5) {
                    UCheckbox(isChecked: $checkA)
                    UCheckbox(isChecked: $checkB)
                    UCheckbox(isChecked: .constant(true)).disabled(true)
                }
            }

            SpecimenSection(title: "Radio") {
                VStack(alignment: .leading, spacing: USpacing.s3) {
                    ForEach(0..<3, id: \.self) { i in
                        HStack(spacing: USpacing.s3) {
                            URadio(isSelected: radioSelection == i) { radioSelection = i }
                            Text("Option \(i + 1)").uText(.body)
                                .foregroundStyle(UColor.textPrimary)
                        }
                    }
                }
            }

            SpecimenSection(title: "Segmented") {
                VStack(spacing: USpacing.s3) {
                    USegmentedControl(selection: $seg2, items: ["List", "Grid"])
                    USegmentedControl(selection: $seg3, items: ["Day", "Week", "Month"])
                }
            }

            SpecimenSection(title: "Stepper") {
                HStack(spacing: USpacing.s6) {
                    Specimen(label: "horizontal (clamps at 0)") {
                        UStepper(value: $stepperH, in: 0...10)
                    }
                    Specimen(label: "verticalCompact") {
                        UStepper(value: $stepperV, in: 0...10, axis: .verticalCompact)
                    }
                }
            }

            SpecimenSection(title: "Slider") {
                VStack(spacing: USpacing.s4) {
                    Specimen(label: "interactive") { USlider(value: $slider) }
                    Specimen(label: "fixed 0") { USlider(value: .constant(0)) }
                    Specimen(label: "fixed 1") { USlider(value: .constant(1)) }
                }
            }
        }
    }
}
