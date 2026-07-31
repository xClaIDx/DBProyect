/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.ResultadoDAO;
import finesi.app.andromeda.modelo.ResultadoDetalle;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "DocenteController", urlPatterns = {"/docente/calificar"})
public class DocenteController extends HttpServlet {

    private final ResultadoDAO resultadoDAO = new ResultadoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null || (!"DOCENTE".equals(user.getRol()) && !"ADMIN".equals(user.getRol()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            long idPostulante = Long.parseLong(request.getParameter("idPostulante"));
            long idAlumno = Long.parseLong(request.getParameter("idAlumno"));
            int idExamen = Integer.parseInt(request.getParameter("idExamen"));
            int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));

            int correctas = Integer.parseInt(request.getParameter("correctas"));
            int incorrectas = Integer.parseInt(request.getParameter("incorrectas"));
            int vacias = Integer.parseInt(request.getParameter("vacias"));

            BigDecimal competencias = new BigDecimal(request.getParameter("notaCompetencias"));
            BigDecimal psicotecnico = new BigDecimal(request.getParameter("notaPsicotecnico"));
            BigDecimal redaccion = new BigDecimal(request.getParameter("notaRedaccion"));
            BigDecimal entrevista = new BigDecimal(request.getParameter("notaEntrevista"));

            ResultadoDetalle rd = new ResultadoDetalle();
            rd.setIdPostulante(idPostulante);
            rd.setIdAlumno(idAlumno);
            rd.setIdExamen(idExamen);
            rd.setCorrectas(correctas);
            rd.setIncorrectas(incorrectas);
            rd.setVacias(vacias);
            rd.setNotaCompetencias(competencias);
            rd.setNotaPsicotecnico(psicotecnico);
            rd.setNotaRedaccion(redaccion);
            rd.setNotaEntrevista(entrevista);

            boolean ok = resultadoDAO.guardarOCalificar(rd, user.getIdUsuario(), idPeriodo);

            if (ok) {
                session.setAttribute("msgExito", "Calificación registrada con éxito.");
            } else {
                session.setAttribute("msgError", "Error al registrar la calificación.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msgError", "Datos inválidos: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/docente/dashboard.jsp");
    }
}