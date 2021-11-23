// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Con esta sentencia indicamos que vamos a cifrar información del contrato..
pragma experimental ABIEncoderV2;

//Lección aparte: * Al referirnos a un tipo de dato hash, se debe de colocar byte(32,64,etc.. según corresponda)..
//                  Cada vez que pasemos un strint por parámetro debe ir acompañado de la palabra reservada 'memory'..

//                * Al ver las cuentas por consola, dentro de truffle.. primero ejecutar 'global = this'..

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notas {
    
    //Dirección del profesor..
    address public profesor;
    
    //Constructor..
    constructor() {
        profesor = msg.sender;
    }
    
    //Mapping para relacionar el hash de la identidad del alumno con su nota en el examen..
    mapping(bytes32 => uint) Notas; 
    
    //Mapping de los alumnos que pidan revisión de su examen para una asignatura..
    mapping(string => string[]) Revisiones;
    
    //Eventos..
    event alumno_evaluado(bytes32, uint); //Devuelve un hash..
    event evento_revision(string);
    
    //Función para evaluar alumnos..
    function evaluar(string memory _asignatura, string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender) {
        //Hash de la identidad del alumno..
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_asignatura, _idAlumno)); //CIFRADO DE INFORMACIÓN, CONVERTIMOS A HASH..
        
        //Relación entre el hash de la identificación del alumno y su nota..
        Notas[hash_idAlumno] = _nota;
        
        //Emición de evento..
        emit alumno_evaluado(hash_idAlumno, _nota);
    }
    
    //Control de las funciones ejecutables por el profesor..
    modifier UnicamenteProfesor(address _direccion) {
        //Requiere que la dirección introducida por parámetro sea igual al owner del contrato..
        require(_direccion == profesor, "No puedes acceder a esta funcion, solo el profesor puede hacerlo");
        _;
    }
    
    //Función para ver las notas de un alumno..
    function verNotas(string memory _asignatura, string memory _idAlumno) public view returns(uint) {
        //Hash de la identidad del alumno..
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_asignatura, _idAlumno));
        
        //Nota asociada al hash del alumno..
        return Notas[hash_idAlumno];
    }
    
    //Función para pedir una revisión del examen..
    function revision(string memory _asignatura, string memory _idAlumno) public {
        //Asignamos al mapping de la _asignatura recibida por parámetro, el _idAlumno que la solicita.. 
        Revisiones[_asignatura].push(_idAlumno);
        
        //Emición de evento..
        emit evento_revision(_idAlumno);
    }
    
    //Función para ver los alumnos que han solicitado revisión de examen..
    function verRevisiones(string memory _asignatura) public view UnicamenteProfesor(msg.sender) returns(string [] memory)  {
        //Retorna las identidades de los alumnos..
        return Revisiones[_asignatura];
    }
}