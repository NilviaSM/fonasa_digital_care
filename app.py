from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

# Configurar conexión a la base de datos
db_config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'fonasa_gestion_clinica'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

#listar_pacientes_mayor_riesgo
@app.route('/listar_pacientes_mayor_riesgo/<int:numero_historia_clinica>', methods=['GET'])
def listar_pacientes_mayor_riesgo(numero_historia_clinica):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    # Obtener el riesgo del paciente dado
    cursor.execute('SELECT riesgo FROM paciente WHERE no_historia_clinica=%s', (numero_historia_clinica,))
    resultado = cursor.fetchone()
    
    if resultado is None:
        return jsonify({"error": "Paciente no encontrado"}), 404

    riesgo_objetivo = resultado['riesgo']

    # Encontrar pacientes con mayor riesgo
    cursor.execute('SELECT * FROM paciente WHERE riesgo > %s', (riesgo_objetivo,))
    pacientes = cursor.fetchall()
    cursor.close()
    connection.close()

    return jsonify(pacientes)

#atender_paciente
@app.route('/atender_paciente/<int:no_historia_clinica>', methods=['POST'])
def atender_paciente(no_historia_clinica):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    # Obtener datos del paciente
    cursor.execute("SELECT prioridad, edad FROM paciente WHERE no_historia_clinica = %s", (no_historia_clinica,))
    paciente = cursor.fetchone()
    
    if not paciente:
        return jsonify({"error": "Paciente no encontrado"}), 404
    
    prioridad = paciente['prioridad']
    edad = paciente['edad']

    consulta_id = None
    
    # Reglas para las diferentes consultas
    if prioridad > 4:
        # Prioridad mayor a 4: atender en urgencia
        cursor.execute("SELECT id FROM consulta WHERE estado = 'en_espera' AND tipo_consulta = 'urgencia' LIMIT 1")
        consulta = cursor.fetchone()
        if consulta:
            consulta_id = consulta['id']
    elif edad <= 15 and prioridad <= 4:
        # Niños: prioridad menor o igual a 4, atender en pediatría
        cursor.execute("SELECT id FROM consulta WHERE estado = 'en_espera' AND tipo_consulta = 'pediatria' LIMIT 1")
        consulta = cursor.fetchone()
        if consulta:
            consulta_id = consulta['id']
    else:
        # Jovenes o ancianos, atender en CGI
        cursor.execute("SELECT id FROM consulta WHERE estado = 'en_espera' AND tipo_consulta = 'cgi' LIMIT 1")
        consulta = cursor.fetchone()
        if consulta:
            consulta_id = consulta['id']

    if not consulta_id:
        # Si no hay consulta disponible, enviar al paciente a la sala de espera
        cursor.execute("UPDATE paciente SET estado = 'sala_espera' WHERE no_historia_clinica = %s", (no_historia_clinica,))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"mensaje": "Paciente enviado a la sala de espera"}), 200
    
    # Asigna la consulta al paciente y marcar la consulta como ocupada
    cursor.execute("UPDATE consulta SET estado = 'ocupada' WHERE id = %s", (consulta_id,))
   
    cursor.execute("INSERT INTO atencion (consulta_id, no_historia_clinica) VALUES (%s, %s)", (consulta_id, no_historia_clinica))
    
    connection.commit()

    cursor.close()
    connection.close()
    return jsonify({"mensaje": "Paciente atendido exitosamente"}), 200

#Liberar consultas
def liberar_consultas():
    connection = get_db_connection()
    try:
        cursor = connection.cursor()

        # Paso 1: Liberar todas las consultas ocupadas
        cursor.execute("UPDATE consulta SET estado = 'en_espera' WHERE estado = 'ocupada'")
        connection.commit()

       
        atender_pacientes_en_espera(connection)

    except Exception as e:
        connection.rollback()  # Rollback en caso de error
        print(f"Error al liberar consultas: {e}")
    finally:
        cursor.close()
        connection.close()

    return jsonify({"mensaje": "Todas las consultas han sido liberadas y los pacientes en espera atendidos"}), 200

def atender_pacientes_en_espera(connection):
    cursor = connection.cursor()
    try:
        # Obtener pacientes en sala de espera ordenados por prioridad
        cursor.execute("SELECT no_historia_clinica FROM paciente WHERE estado = 'en_espera' ORDER BY prioridad DESC")
        pacientes = cursor.fetchall()

        for paciente in pacientes:
            no_historia_clinica = paciente['no_historia_clinica']
            # Intenta atender a cada paciente
            if not atender_paciente_individual(no_historia_clinica, cursor, connection):
                # Si no se puede atender, se mantiene en la sala de espera
                continue

        connection.commit()


    except Exception as e:
        connection.rollback()  # Rollback en caso de error
        print(f"Error al atender pacientes en espera: {e}")
    finally:
        cursor.close()

def atender_paciente_individual(no_historia_clinica, cursor, connection):
    try:
        # Intenta encontrar una consulta disponible
        cursor.execute("SELECT id FROM consulta WHERE estado = 'en_espera' LIMIT 1")
        consulta = cursor.fetchone()
        if consulta:
            consulta_id = consulta['id']
            # Asignar la consulta al paciente y marcar la consulta como ocupada
            cursor.execute("UPDATE consulta SET estado = 'ocupada' WHERE id = %s", (consulta_id,))
            cursor.execute("INSERT INTO atencion (consulta_id, no_historia_clinica) VALUES (%s, %s)", (consulta_id, no_historia_clinica))
            return True
        return False
    except Exception as e:
        connection.rollback()
        print(f"Error al intentar atender al paciente {no_historia_clinica}: {e}")
        return False





if __name__ == '__main__':
    app.run(debug=True)
