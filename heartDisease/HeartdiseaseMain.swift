              
              
import SwiftUI

@main 
struct heartdiseaseMain : App {

	var body: some Scene {
	        WindowGroup {
	            ContentView(model: ModelFacade.getInstance())
	        }
	    }
	} 
