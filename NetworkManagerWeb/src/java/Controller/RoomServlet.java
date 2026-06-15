package Controller;

import Models.RoomDAO;
import Models.RoomDTO;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RoomServlet extends HttpServlet {

    RoomDAO roomDAO = new RoomDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "roomList";
        }

        switch (action) {
            case "roomList":
                listRooms(request, response);
                break;

            case "roomAdd":
                showAddForm(request, response);
                break;

            case "roomEdit":
                showEditForm(request, response);
                break;

            case "roomInsert":
                insertRoom(request, response);
                break;

            case "roomUpdate":
                updateRoom(request, response);
                break;

            case "roomDelete":
                deleteRoom(request, response);
                break;

            default:
                listRooms(request, response);
                break;
        }
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<RoomDTO> rooms = roomDAO.ListAll();
        request.setAttribute("rooms", rooms);

        RequestDispatcher rd = request.getRequestDispatcher("room-list.jsp");
        rd.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("returnTo", request.getParameter("returnTo"));

        RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
        rd.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        RoomDTO room = roomDAO.searchById(id);

        request.setAttribute("room", room);
        request.setAttribute("returnTo", request.getParameter("returnTo"));

        RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
        rd.forward(request, response);
    }

    private void insertRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomName = cleanText(request.getParameter("roomName"));
        String building = cleanText(request.getParameter("building"));

        int floor = parseIntOrDefault(request.getParameter("floor"), 1);
        int capacity = parseIntOrDefault(request.getParameter("capacity"), 0);

        if (roomName == null || roomName.isEmpty()) {
            request.setAttribute("error", "Room name is required.");
            request.setAttribute("formRoom", new RoomDTO(0, roomName, building, floor, capacity));

            RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
            rd.forward(request, response);
            return;
        }

        RoomDTO room = new RoomDTO(0, roomName, building, floor, capacity);

        boolean success = roomDAO.insert(room);

        if (!success) {
            request.setAttribute("error", "Cannot insert room.");
            request.setAttribute("formRoom", room);

            RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
            rd.forward(request, response);
            return;
        }

        redirectAfterAction(request, response);
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));

        String roomName = cleanText(request.getParameter("roomName"));
        String building = cleanText(request.getParameter("building"));

        int floor = parseIntOrDefault(request.getParameter("floor"), 1);
        int capacity = parseIntOrDefault(request.getParameter("capacity"), 0);

        if (roomName == null || roomName.isEmpty()) {
            request.setAttribute("error", "Room name is required.");
            request.setAttribute("room", new RoomDTO(roomId, roomName, building, floor, capacity));

            RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
            rd.forward(request, response);
            return;
        }

        RoomDTO room = new RoomDTO(roomId, roomName, building, floor, capacity);

        boolean success = roomDAO.update(room);

        if (!success) {
            request.setAttribute("error", "Cannot update room.");
            request.setAttribute("room", room);

            RequestDispatcher rd = request.getRequestDispatcher("room-form.jsp");
            rd.forward(request, response);
            return;
        }

        redirectAfterAction(request, response);
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));

        RoomDTO room = roomDAO.searchById(roomId);

        if (room != null) {
            roomDAO.remove(room);
        }

        redirectAfterAction(request, response);
    }
    private void redirectAfterAction(HttpServletRequest request,
        HttpServletResponse response) throws IOException {

    String returnTo = request.getParameter("returnTo");

    if ("dashboard".equals(returnTo)) {
        response.sendRedirect("staffDashboard.jsp?page=rooms");
        return;
    }

    response.sendRedirect("MainController?action=roomList");
}

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String cleanText(String value) {
        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty() ? null : value;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "RoomServlet";
    }
}