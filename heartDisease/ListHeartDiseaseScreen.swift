
import SwiftUI

struct ListHeartDiseaseScreen: View {
    @ObservedObject var model : ModelFacade = ModelFacade.getInstance()

     var body: some View
     { List(model.currentHeartDiseases){ instance in 
     	ListHeartDiseaseRowScreen(instance: instance) }
       .onAppear(perform: { model.listHeartDisease() })
     }
    
}

struct ListHeartDiseaseScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListHeartDiseaseScreen(model: ModelFacade.getInstance())
    }
}

