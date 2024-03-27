//
//  ContentView.swift
//  TestApp
//
//  Created by Shania Brown on 3/26/24.
//
import SwiftUI
import RealityKit
import SceneKit

struct ContentView: View {
    @State private var showModelScreen = false
    
    var body: some View {
        if showModelScreen {
            ModelScreen(backButtonAction: { showModelScreen = false })
        } else {
            StartScreen(startButtonAction: { showModelScreen = true })
        }
    }
}

struct StartScreen: View {
    var startButtonAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Learn about Earth 🌎")
                .font(.extraLargeTitle2)
                .padding()
            
            Button("Learn More") {
                startButtonAction()
            }
            .font(.extraLargeTitle2)
            .padding()
        }
    }
}

struct ModelScreen: View {
    @State private var modelNode: SCNNode?
    @State private var isLoading = false
    var backButtonAction: () -> Void

    var body: some View {
        VStack {
            Text("All about Earth")
                .font(.extraLargeTitle)
                .padding()
            
            // Add any additional text or information about Earth here
            Text("Earth is the third planet from the Sun and the only astronomical object known to harbor life. About 71% of Earth's surface is covered with water, mostly by oceans, and the remaining 29% is land consisting of continents and islands.")
                .font(.largeTitle)
                .padding()
            
            if isLoading {
                ProgressView("Loading model...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let modelNode = modelNode {
                ModelView(modelNode: modelNode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Failed to load model")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button("Back") {
                backButtonAction()
            }
            .font(.largeTitle)
            .padding()
        }
        .padding()
        .onAppear {
            isLoading = true
            loadModel()
        }
    }
    
    func loadModel() {
        guard let url = Bundle.main.url(forResource: "earth", withExtension: "obj") else {
            print("Model file not found")
            return
        }
        
        DispatchQueue.global().async {
            do {
                let scene = try SCNScene(url: url, options: nil)
                let modelNode = SCNNode()
                
                for childNode in scene.rootNode.childNodes {
                    modelNode.addChildNode(childNode.clone())
                }
                
                DispatchQueue.main.async {
                    self.modelNode = modelNode
                    isLoading = false
                }
            } catch {
                print("Error loading model: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}

struct ModelView: UIViewRepresentable {
    let modelNode: SCNNode

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.isUserInteractionEnabled = true
        sceneView.scene?.rootNode.addChildNode(modelNode)
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the SCNView if needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


