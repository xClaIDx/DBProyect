/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.DocenteDAO;
import finesi.app.andromeda.modelo.Docente;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionDocentesController", urlPatterns = {"/admin/docentes"})
public class GestionDocentesController extends HttpServlet {

    private final DocenteDAO docenteDAO = new DocenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession(false);
        Usuario user = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

        if (user == null || !"ADMIN".equals(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sin_permiso");
            return;
        }

        List<Docente> lista = docenteDAO.listarDocentes();
        request.setAttribute("listaDocentes", lista);
        request.getRequestDispatcher("/admin/docentes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            Docente d = new Docente();
            d.setNumDocumento(request.getParameter("numDocumento"));
            d.setNombres(request.getParameter("nombres"));
            d.setApPaterno(request.getParameter("apPaterno"));
            d.setApMaterno(request.getParameter("apMaterno"));
            d.setEspecialidad(request.getParameter("especialidad"));

            boolean exito = docenteDAO.registrarDocenteConUsuario(d);
            request.getSession().setAttribute(exito ? "msgExitoAdmin" : "msgErrorAdmin", 
                exito ? "Docente registrado con éxito (Credenciales: DNI/DNI)" : "Error al registrar docente.");

        } else if ("eliminar".equals(accion)) {
            int idDocente = Integer.parseInt(request.getParameter("idDocente"));
            boolean exito = docenteDAO.eliminarDocente(idDocente);
            request.getSession().setAttribute(exito ? "msgExitoAdmin" : "msgErrorAdmin", 
                exito ? "Docente eliminado correctamente." : "Error al eliminar docente (podría tener calificaciones asignadas).");
        }

        response.sendRedirect(request.getContextPath() + "/admin/docentes");
    }
}