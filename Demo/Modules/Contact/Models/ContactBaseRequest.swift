//
//  ContactBaseRequest.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//
 
struct ContactBaseRequest: Codable{
    let type: [TargetRequest]
    let field_nombre_completo :  [GenericValue]
    let field_fecha_de_nacimiento:  [GenericValue]
    let field_correo_electronico :  [GenericValue]
    let field_mensaje:  [GenericValue]
    
    init(type: [TargetRequest], name:  [GenericValue],
         date:   [GenericValue], email:  [GenericValue],
         message:   [GenericValue]) {
        self.type = type
        self.field_nombre_completo = name
        self.field_fecha_de_nacimiento = date
        self.field_correo_electronico = email
        self.field_mensaje = message
    }
}

struct TargetRequest: Codable {
    let target_id: String
    
    init(targetId: String) {
        self.target_id = targetId
    }
}

struct GenericValue: Codable {
    let value: String
    
    init(value: String) {
        self.value = value
    }
}
