  @P1
  Feature: : Matricula de cursos
    Como alumno de CIBERTEC
    Quiero matricularme en mis cursos
    Para llevarlos en el ciclo

    Background:
      Given que el alumno "i202610001" inicia sesión con clave "Cibertec2026"

    Scenario: Cotizar el curso de mi fila
      When cotiza el curso "QA5517" para el alumno "i202610001"
      Then la respuesta HTTP debe ser 200
      And la cotización muestra 3 créditos, subtotal 360.0, descuento 20 y total 288.0

    Scenario: Matricularse y pagar el curso de mi fila
      When el alumno "i202610001" registra su matrícula en el curso "QA5517"
      Then la respuesta HTTP debe ser 201
      And la matrícula creada tiene estado "REGISTRADA" y monto 288.0
      And el cuerpo de la respuesta cumple el esquema "schemas/matricula.json"
      When paga la matrícula registrada usando el método "TARJETA"
      Then la respuesta HTTP debe ser 200
      And la matrícula pagada tiene estado "PAGADA" y fecha de pago registrada
      When consulta el listado de sus pagos
      Then la respuesta HTTP debe ser 200
      And existe el pago de la matrícula con método "TARJETA" y formato de operación "^OP-[0-9]{6}$"

    Scenario: Regla de negocio que debe fallar por cruce de horario
      When el alumno "i202610001" registra su matrícula en el curso "PS5511"
      Then la respuesta HTTP debe ser 409
      And el error devuelto tiene código "CRUCE_HORARIO"
      And el cuerpo de la respuesta cumple el esquema "schemas/error.json"