//Lección aparte: *Al testear, si la acción que estamos comprobando no realiza cambios sobre la Blockchain..
//                 debe de ser llamada .call().. Con esto indicamos que solo estamos visualizando datos..

//Llamada al contrato..
const notas = artifacts.require('notas');

contract('notas', accounts => {
    it('1.Funcion: evaluar(string memory _asignatura, string memory _idAlumno, uint _nota)', async () => {
        //Smart Contract desplegado..
        let instance = await notas.deployed();

        //Llamada al método de evaluación deñ Smart Contract..
        const tx = await instance.evaluar('Matematicas', '12345X', 8, { from: accounts[0] });
        const tx2 = await instance.evaluar('Biologia', '12345X', 7, { from: accounts[0] });

        //Imprimir valores..
        console.log(accounts[0]); //Dirección del profesor..
        console.log(tx);         //Transacción de la evaluación académica de Matematicas..
        console.log(tx2);       //Transacción de la evaluación académica de Biologia..

        //Comprobación de la información de la Blockchain..
        const nota_alumno_mates = await instance.verNotas.call('Matematicas', '12345X', { from: accounts[1] });
        const nota_alumno_biologia = await instance.verNotas.call('Biologia', '12345X', { from: accounts[1] });

        //Condición para pasar el test: nota_alumno_mates = 8 .. nota_alumno_biologia = 7..
        console.log(nota_alumno_mates);
        console.log(nota_alumno_biologia);

        //Verificaciones..
        assert.equal(nota_alumno_mates, 8);
        assert.equal(nota_alumno_biologia, 7);
    });

    it('2. Función: revision(string memory _asignatura, string memory _idAlumno)', async () => {
        //Smart Contract desplegado..
        let instance = await notas.deployed();

        //Lamada al método de revisar examenes..
        const rev = await instance.revision('Matematicas', '12345X', { from: accounts[1] });
        
        const evaluacion_maria = await instance.evaluar('Musica', '02468T', 5, {from: accounts[0]});
        console.log(evaluacion_maria);
        const rev2 = await instance.revision('Musica', '02468T', { from: accounts[2] });

        //Imprimir los valores recibidos de la revisión..
        console.log(rev);
        console.log(rev2);

        //Verificación del test..
        const id_alumno_mates = await instance.verRevisiones.call('Matematicas', { from: accounts[0] });
        const id_alumno_musica = await instance.verRevisiones.call('Musica', { from: accounts[0] });

        console.log(id_alumno_mates);
        console.log(id_alumno_musica);

        //Comprobación de los datos de las revisiones..
        assert.equal(id_alumno_mates[0], '12345X');
        assert.equal(id_alumno_musica[0], '02468T');
    });


});