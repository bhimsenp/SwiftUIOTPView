import SwiftUI

struct OTPView: View {
    @ObservedObject var viewModel: OTPViewModel
    let spacing: CGFloat
    private let aspectRatio: CGFloat = 0.9

    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: spacing) {
                    ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, _ in
                        digitTextField(index: index)
                    }
                }
                TextField("", text: $viewModel.enteredOTP, onEditingChanged: { changed in
                    viewModel.focusChanged(changed)
                })
                .keyboardType(viewModel.keyboardType)
                .frame(height: 70)
                .accentColor(.clear)
                .foregroundColor(.clear)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder private func digitTextField(index: Int) -> some View {
        let isFocused = viewModel.focusedItem == index
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer()
                Text(viewModel.items[index].digit)
                    .tag(index)
                    .accentColor(.black)
                if isFocused {
                    DummyCursor()
                }
                Spacer()
            }
            .frame(height: geometry.size.width/aspectRatio)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }.scaledToFit()
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = OTPViewModel(digits: 6, onOTPChanged: { _ in })
        vm.focusedItem = 0
        return OTPView(viewModel: vm, spacing: 10)
    }
}
