	                  
import Foundation
import SwiftUI

/* This code requires OclFile.swift */

func initialiseOclFile()
{ 
  //let systemIn = createByPKOclFile(key: "System.in")
  //let systemOut = createByPKOclFile(key: "System.out")
  //let systemErr = createByPKOclFile(key: "System.err")
}

/* This metatype code requires OclType.swift */

func initialiseOclType()
{ let intOclType = createByPKOclType(key: "int")
  intOclType.actualMetatype = Int.self
  let doubleOclType = createByPKOclType(key: "double")
  doubleOclType.actualMetatype = Double.self
  let longOclType = createByPKOclType(key: "long")
  longOclType.actualMetatype = Int64.self
  let stringOclType = createByPKOclType(key: "String")
  stringOclType.actualMetatype = String.self
  let sequenceOclType = createByPKOclType(key: "Sequence")
  sequenceOclType.actualMetatype = type(of: [])
  let anyset : Set<AnyHashable> = Set<AnyHashable>()
  let setOclType = createByPKOclType(key: "Set")
  setOclType.actualMetatype = type(of: anyset)
  let mapOclType = createByPKOclType(key: "Map")
  mapOclType.actualMetatype = type(of: [:])
  let voidOclType = createByPKOclType(key: "void")
  voidOclType.actualMetatype = Void.self
	
  let heartDiseaseOclType = createByPKOclType(key: "HeartDisease")
  heartDiseaseOclType.actualMetatype = HeartDisease.self

  let heartDiseaseId = createOclAttribute()
  	  heartDiseaseId.name = "id"
  	  heartDiseaseId.type = stringOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseId)
  let heartDiseaseAge = createOclAttribute()
  	  heartDiseaseAge.name = "age"
  	  heartDiseaseAge.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseAge)
  let heartDiseaseSex = createOclAttribute()
  	  heartDiseaseSex.name = "sex"
  	  heartDiseaseSex.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseSex)
  let heartDiseaseCp = createOclAttribute()
  	  heartDiseaseCp.name = "cp"
  	  heartDiseaseCp.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseCp)
  let heartDiseaseTrestbps = createOclAttribute()
  	  heartDiseaseTrestbps.name = "trestbps"
  	  heartDiseaseTrestbps.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseTrestbps)
  let heartDiseaseChol = createOclAttribute()
  	  heartDiseaseChol.name = "chol"
  	  heartDiseaseChol.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseChol)
  let heartDiseaseFbs = createOclAttribute()
  	  heartDiseaseFbs.name = "fbs"
  	  heartDiseaseFbs.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseFbs)
  let heartDiseaseRestecg = createOclAttribute()
  	  heartDiseaseRestecg.name = "restecg"
  	  heartDiseaseRestecg.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseRestecg)
  let heartDiseaseThalach = createOclAttribute()
  	  heartDiseaseThalach.name = "thalach"
  	  heartDiseaseThalach.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseThalach)
  let heartDiseaseExang = createOclAttribute()
  	  heartDiseaseExang.name = "exang"
  	  heartDiseaseExang.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseExang)
  let heartDiseaseOldpeak = createOclAttribute()
  	  heartDiseaseOldpeak.name = "oldpeak"
  	  heartDiseaseOldpeak.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseOldpeak)
  let heartDiseaseSlope = createOclAttribute()
  	  heartDiseaseSlope.name = "slope"
  	  heartDiseaseSlope.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseSlope)
  let heartDiseaseCa = createOclAttribute()
  	  heartDiseaseCa.name = "ca"
  	  heartDiseaseCa.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseCa)
  let heartDiseaseThal = createOclAttribute()
  	  heartDiseaseThal.name = "thal"
  	  heartDiseaseThal.type = intOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseThal)
  let heartDiseaseOutcome = createOclAttribute()
  	  heartDiseaseOutcome.name = "outcome"
  	  heartDiseaseOutcome.type = stringOclType
  	  heartDiseaseOclType.attributes.append(heartDiseaseOutcome)
}

func instanceFromJSON(typeName: String, json: String) -> AnyObject?
	{ let jdata = json.data(using: .utf8)!
	  let decoder = JSONDecoder()
	  if typeName == "String"
	  { let x = try? decoder.decode(String.self, from: jdata)
	      return x as AnyObject
	  }
  return nil
	}

class ModelFacade : ObservableObject {
		                      
	static var instance : ModelFacade? = nil
	private var modelParser : ModelParser? = ModelParser(modelFileInfo: ModelFile.modelInfo)
	var db : DB?
		
	// path of document directory for SQLite database (absolute path of db)
	let dbpath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
	var fileSystem : FileAccessor = FileAccessor()

	static func getInstance() -> ModelFacade { 
		if instance == nil
	     { instance = ModelFacade() 
	       initialiseOclFile()
	       initialiseOclType() }
	    return instance! }
	                          
	init() { 
		// init
		db = DB.obtainDatabase(path: "\(dbpath)/myDatabase.sqlite3")
		loadHeartDisease()
	}
	      
	@Published var currentHeartDisease : HeartDiseaseVO? = HeartDiseaseVO.defaultHeartDiseaseVO()
	@Published var currentHeartDiseases : [HeartDiseaseVO] = [HeartDiseaseVO]()

	func createHeartDisease(x : HeartDiseaseVO) {
		  let res : HeartDisease = createByPKHeartDisease(key: x.id)
				res.id = x.id
		res.age = x.age
		res.sex = x.sex
		res.cp = x.cp
		res.trestbps = x.trestbps
		res.chol = x.chol
		res.fbs = x.fbs
		res.restecg = x.restecg
		res.thalach = x.thalach
		res.exang = x.exang
		res.oldpeak = x.oldpeak
		res.slope = x.slope
		res.ca = x.ca
		res.thal = x.thal
		res.outcome = x.outcome
		  currentHeartDisease = x
		  do { try db?.createHeartDisease(heartDiseasevo: x) }
		  catch { print("Error creating HeartDisease") }
	}
		
	func cancelCreateHeartDisease() {
		//cancel function
	}
	
	func deleteHeartDisease(id : String) {
		  if db != nil
	      { db!.deleteHeartDisease(val: id) }
	     	currentHeartDisease = nil
	}
		
	func cancelDeleteHeartDisease() {
		//cancel function
	}
			
	func cancelEditHeartDisease() {
		//cancel function
	}

	func cancelSearchHeartDiseaseByAge() {
	//cancel function
}

    func classifyHeartDisease(x : String) -> String {
        guard let heartDisease = getHeartDiseaseByPK(val: x)
        else {
            return "Please selsect valid id"
        }
        
        guard let result = self.modelParser?.runModel(
          input0: Float((heartDisease.age - 29) / (77 - 29)),
          input1: Float(heartDisease.sex),
          input2: Float((heartDisease.cp - 0) / (3 - 0)),
          input3: Float((heartDisease.trestbps - 94) / (200 - 94)),
          input4: Float((heartDisease.chol - 126) / (564 - 126)),
          input5: Float(heartDisease.fbs),
          input6: Float((heartDisease.restecg - 0) / (2 - 0)),
          input7: Float((heartDisease.thalach - 71) / (202 - 71)),
          input8: Float((heartDisease.exang)),
          input9: Float((heartDisease.oldpeak - 0) / (6.2 - 0)),
          input10: Float((heartDisease.slope - 0) / (2 - 0)),
          input11: Float((heartDisease.ca - 0) / (4 - 0)),
          input12: Float((heartDisease.thal - 0) / (3 - 0))
        ) else{
            return "Error"
        }
        
        heartDisease.outcome = result
        persistHeartDisease(x: heartDisease)
        
        return result
	}
	
	func cancelClassifyHeartDisease() {
		//cancel function
	}
	    

	func loadHeartDisease() {
		let res : [HeartDiseaseVO] = listHeartDisease()
		
		for (_,x) in res.enumerated() {
			let obj = createByPKHeartDisease(key: x.id)
	        obj.id = x.getId()
        obj.age = x.getAge()
        obj.sex = x.getSex()
        obj.cp = x.getCp()
        obj.trestbps = x.getTrestbps()
        obj.chol = x.getChol()
        obj.fbs = x.getFbs()
        obj.restecg = x.getRestecg()
        obj.thalach = x.getThalach()
        obj.exang = x.getExang()
        obj.oldpeak = x.getOldpeak()
        obj.slope = x.getSlope()
        obj.ca = x.getCa()
        obj.thal = x.getThal()
        obj.outcome = x.getOutcome()
			}
		 currentHeartDisease = res.first
		 currentHeartDiseases = res
		}
		
  		func listHeartDisease() -> [HeartDiseaseVO] {
			if db != nil
			{ currentHeartDiseases = (db?.listHeartDisease())!
			  return currentHeartDiseases
			}
			currentHeartDiseases = [HeartDiseaseVO]()
			let list : [HeartDisease] = HeartDiseaseAllInstances
			for (_,x) in list.enumerated()
			{ currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
			return currentHeartDiseases
		}
				
		func stringListHeartDisease() -> [String] { 
			currentHeartDiseases = listHeartDisease()
			var res : [String] = [String]()
			for (_,obj) in currentHeartDiseases.enumerated()
			{ res.append(obj.toString()) }
			return res
		}
				
		func getHeartDiseaseByPK(val: String) -> HeartDisease? {
			var res : HeartDisease? = HeartDisease.getByPKHeartDisease(index: val)
			if res == nil && db != nil
			{ let list = db!.searchByHeartDiseaseid(val: val)
			if list.count > 0
			{ res = createByPKHeartDisease(key: val)
			}
		  }
		  return res
		}
				
		func retrieveHeartDisease(val: String) -> HeartDisease? {
			let res : HeartDisease? = getHeartDiseaseByPK(val: val)
			return res 
		}
				
		func allHeartDiseaseids() -> [String] {
			var res : [String] = [String]()
			for (_,item) in currentHeartDiseases.enumerated()
			{ res.append(item.id + "") }
			return res
		}
				
		func setSelectedHeartDisease(x : HeartDiseaseVO)
			{ currentHeartDisease = x }
				
		func setSelectedHeartDisease(i : Int) {
			if 0 <= i && i < currentHeartDiseases.count
			{ currentHeartDisease = currentHeartDiseases[i] }
		}
				
		func getSelectedHeartDisease() -> HeartDiseaseVO?
			{ return currentHeartDisease }
				
		func persistHeartDisease(x : HeartDisease) {
			let vo : HeartDiseaseVO = HeartDiseaseVO(x: x)
			editHeartDisease(x: vo)
		}
			
		func editHeartDisease(x : HeartDiseaseVO) {
			let val : String = x.id
			let res : HeartDisease? = HeartDisease.getByPKHeartDisease(index: val)
			if res != nil {
			res!.id = x.id
		res!.age = x.age
		res!.sex = x.sex
		res!.cp = x.cp
		res!.trestbps = x.trestbps
		res!.chol = x.chol
		res!.fbs = x.fbs
		res!.restecg = x.restecg
		res!.thalach = x.thalach
		res!.exang = x.exang
		res!.oldpeak = x.oldpeak
		res!.slope = x.slope
		res!.ca = x.ca
		res!.thal = x.thal
		res!.outcome = x.outcome
		}
		currentHeartDisease = x
			if db != nil
			 { db!.editHeartDisease(heartDiseasevo: x) }
		 }
			
	    func cancelHeartDiseaseEdit() {
	    	//cancel function
	    }
	    
 	func searchByHeartDiseaseid(val : String) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseid(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.id == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseage(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseage(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.age == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasesex(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasesex(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.sex == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasecp(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasecp(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.cp == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasetrestbps(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasetrestbps(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.trestbps == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasechol(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasechol(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.chol == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasefbs(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasefbs(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.fbs == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaserestecg(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaserestecg(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.restecg == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasethalach(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasethalach(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.thalach == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseexang(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseexang(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.exang == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseoldpeak(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseoldpeak(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.oldpeak == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseslope(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseslope(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.slope == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseca(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseca(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.ca == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseasethal(val : Int) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseasethal(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.thal == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  
 	func searchByHeartDiseaseoutcome(val : String) -> [HeartDiseaseVO]
		  { 
		      if db != nil
		        { let res = (db?.searchByHeartDiseaseoutcome(val: val))!
		          return res
		        }
		    currentHeartDiseases = [HeartDiseaseVO]()
		    let list : [HeartDisease] = HeartDiseaseAllInstances
		    for (_,x) in list.enumerated()
		    { if x.outcome == val
		      { currentHeartDiseases.append(HeartDiseaseVO(x: x)) }
		    }
		    return currentHeartDiseases
		  }
		  

	}
