import SwiftUI

struct DummyCursor: View {

    private var foregroundColor: Color?
    private var size: CGFloat = 14.0
    @State private var on: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.black)
                .frame(width: 2, height: (2.29925 * size + 3.28947) / 2)
                .opacity(on ? 1 : 0)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.blinkCursor()
                let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    self.blinkCursor()
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }

    private func blinkCursor() {
        withAnimation(.easeInOut(duration: 12.0 / 60.0)) {
            self.on = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 29.0 / 60.0) {
            withAnimation(.easeInOut(duration: 8.0 / 60.0)) {
                self.on = true
            }
        }
    }
}
