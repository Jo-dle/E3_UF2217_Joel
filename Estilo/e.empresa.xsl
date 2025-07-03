<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Registro de Personal</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>


      </head>
      <body class="container mt-4">

        <h1 class="text-center mb-4">Registro de Personal</h1>

        <!-- Navegación por pestañas -->
        <nav>
          <div class="nav nav-tabs" id="nav-tab" role="tablist">
            <button class="nav-link active" id="nav-empleados-tab" data-bs-toggle="tab" data-bs-target="#empleados" type="button" role="tab" aria-controls="empleados" aria-selected="true">Empleados</button>
            <button class="nav-link" id="nav-consultores-tab" data-bs-toggle="tab" data-bs-target="#consultores" type="button" role="tab" aria-controls="consultores" aria-selected="false">Consultores</button>
            <button class="nav-link" id="nav-departamentos-tab" data-bs-toggle="tab" data-bs-target="#departamentos" type="button" role="tab" aria-controls="departamentos" aria-selected="false">Departamentos</button>
          </div>
        </nav>

        <div class="tab-content mt-3" id="nav-tabContent">

          <!-- Tab Empleados -->
          <div class="tab-pane fade show active" id="empleados" role="tabpanel" aria-labelledby="nav-empleados-tab">
            <!-- Combo de Departamentos -->
            <div class="mb-3">
              <label for="filtroDepartamento" class="form-label"><strong>Filtrar por Departamento:</strong></label>
              <select id="filtroDepartamento" class="form-select" onchange="filtrarPorDepartamento()">
                <option value="todos">Todos</option>
                <xsl:for-each select="registroPersonal/departamentos/departamento">
                  <xsl:sort select="nombre"/>
                  <option value="{nombre}">
                    <xsl:value-of select="nombre"/>
                  </option>
                </xsl:for-each>
              </select>
            </div>

            <div class="table-responsive">
              <table id="tablaEmpleados" class="table table-bordered table-striped">
                <thead>
                  <tr>
                    <th>Código</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Email</th>
                    <th>Teléfono</th>
                    <th>Departamento</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each select="registroPersonal/empleados/empleado">
                    <tr class="empleado" data-departamento="{departamento}">
                      <td><xsl:value-of select="@CED"/></td>
                      <td><xsl:value-of select="nombre"/></td>
                      <td><xsl:value-of select="sexo"/></td>
                      <td><xsl:value-of select="contacto/email"/></td>
                      <td><xsl:value-of select="contacto/telefono"/></td>
                      <td><xsl:value-of select="departamento"/></td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Tab Consultores -->
          <div class="tab-pane fade" id="consultores" role="tabpanel" aria-labelledby="nav-consultores-tab">
            <div class="table-responsive">
              <table id="tablaConsultores" class="table table-bordered table-striped">
                <thead>
                  <tr>
                    <th>Código</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Email</th>
                    <th>Teléfono</th>
                    <th>Departamento</th>
                    <th>Empresa Externa</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each select="registroPersonal/consultores/consultor">
                    <tr>
                      <td><xsl:value-of select="@CCD"/></td>
                      <td><xsl:value-of select="nombre"/></td>
                      <td><xsl:value-of select="sexo"/></td>
                      <td><xsl:value-of select="contacto/email"/></td>
                      <td><xsl:value-of select="contacto/telefono"/></td>
                      <td><xsl:value-of select="departamento"/></td>
                      <td><xsl:value-of select="empresaExterna"/></td>
                    </tr>
                  </xsl:for-each>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Tab Departamentos -->
          <div class="tab-pane fade" id="departamentos" role="tabpanel" aria-labelledby="nav-departamentos-tab">
            <xsl:for-each select="registroPersonal/departamentos/departamento">
              <div class="card mb-3">
                <div class="card-header bg-primary text-white">
                  <strong><xsl:value-of select="nombre"/></strong> - Director: <xsl:value-of select="director"/>
                </div>
                <div class="card-body">
                  <p><strong>Dirección:</strong></p>
                  <ul>
                    <li>Calle: <xsl:value-of select="direccion/calle"/></li>
                    <li>Ciudad: <xsl:value-of select="direccion/ciudad"/></li>
                    <li>Código Postal: <xsl:value-of select="direccion/codigoPostal"/></li>
                  </ul>
                  <p><strong>Empleados:</strong></p>
                  <ul>
                    <xsl:for-each select="empleados/empleado">
                      <xsl:variable name="ced" select="@CED"/>
                      <xsl:for-each select="/registroPersonal/empleados/empleado[@CED=$ced]">
                        <li>
                          <xsl:value-of select="nombre"/> (<xsl:value-of select="@CED"/>)
                        </li>
                      </xsl:for-each>
                    </xsl:for-each>
                  </ul>
                </div>
              </div>
            </xsl:for-each>
          </div>

        </div>

        <script>
        function filtrarPorDepartamento() {
          const filtro = document.getElementById('filtroDepartamento').value;
          const filas = document.querySelectorAll('.empleado');

          filas.forEach(fila => {
              const depto = fila.getAttribute('data-departamento');
              if (filtro === 'todos' || filtro === depto) {
                  fila.style.display = '';
              } else {
                  fila.style.display = 'none';
              }
          });
        }
        </script>
        <!-- Bootstrap y DataTables JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
        function filtrarPorDepartamento() {
        const filtro = document.getElementById('filtroDepartamento').value;
        const filas = document.querySelectorAll('.empleado');

        filas.forEach(fila => {
            const depto = fila.getAttribute('data-departamento');
            if (filtro === 'todos' || filtro === depto) {
                fila.style.display = '';
            } else {
                fila.style.display = 'none';
            }
        });
        }

        document.addEventListener("DOMContentLoaded", function() {
        new DataTable('#tablaEmpleados');
        new DataTable('#tablaConsultores');
        });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
