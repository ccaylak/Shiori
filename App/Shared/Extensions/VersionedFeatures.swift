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
    func buttonSizingFullWidth() -> some View {
        if #available(iOS 26.0, *) {
            self
                .buttonSizing(.flexible)
                .padding(.horizontal)
        } else {
            self
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
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
    
    //iOS 18
    @ViewBuilder
    func zoomTransitionIfAvailable<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.navigationTransition(
                .zoom(sourceID: id, in: namespace)
            )
        } else {
            self
        }
    }
}
