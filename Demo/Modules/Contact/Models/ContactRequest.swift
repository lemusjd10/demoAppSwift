//
//  ContactRequest.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//
 
struct ContactRequest: Codable {
    let type: String?
    let field_nombre_completo: String
    let field_fecha_de_nacimiento: String
    let field_correo_electronico: String
    let field_mensaje: String
    
    init(type: String? = "contacto", name: String,
         date: String, email: String, message: String) {
        self.type = type
        self.field_nombre_completo = name
        self.field_fecha_de_nacimiento = date
        self.field_correo_electronico = email
        self.field_mensaje = message
    }
}
