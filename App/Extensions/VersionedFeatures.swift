import SwiftUI

extension View {
    
    //iOS 26
    @ViewBuilder
    func noScrollEdgeEffect(for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            self.scrollEdgeEffectHidden(for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func softScrollEdgeEffect(for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            self.scrollEdgeEffectStyle(.soft, for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func hardScrollEdgeEffect(for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            self.scrollEdgeEffectStyle(.hard, for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func automaticScrollEdgeEffect(for edges: Edge.Set = .all) -> some View {
        if #available(iOS 26.0, *) {
            self.scrollEdgeEffectStyle(.automatic, for: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func glassEffectOrMaterial() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self.background(Material.ultraThin)
        }
    }
    
    @ViewBuilder
    func borderedProminentOrGlassProminent() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}
