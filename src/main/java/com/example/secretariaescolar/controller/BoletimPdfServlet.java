package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.util.Conexao;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.awt.Color;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/aluno/boletim/pdf")
public class BoletimPdfServlet extends HttpServlet {

    private static final Color TEXT = Color.decode("#283565");
    private static final Color BG = Color.decode("#FAFAFA");
    private static final Color BAR = Color.decode("#274855");

    private static final String LOGO_WEB_PATH = "/pages/assets/logo.png";

    private static class Linha {
        String disciplina;
        Double sem1;
        Double sem2;
        Double geral;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario.getId_tipo_user() != 1) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Integer idAluno = null;
        String turma = "—";

        String sqlAlunoTurma = """
                    SELECT a.id_aluno, t.nome AS turma
                    FROM aluno a
                    JOIN turma t ON t.id_turma = a.id_turma
                    WHERE a.id_user = ?
                """;

        try (Connection conn = Conexao.conectar();
                PreparedStatement st = conn.prepareStatement(sqlAlunoTurma)) {

            st.setInt(1, usuario.getId_user());

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    idAluno = rs.getInt("id_aluno");
                    turma = rs.getString("turma");
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Erro ao buscar aluno/turma: " + e.getMessage(), e);
        }

        if (idAluno == null) {
            response.sendError(404, "Aluno não encontrado para esse usuário.");
            return;
        }

        List<Linha> linhas = new ArrayList<>();

        String sqlBoletim = """
                    SELECT
                      d.nome AS disciplina,
                      ROUND(AVG(CASE WHEN n.semestre::text = '1' THEN n.valor END)::numeric, 1) AS media_1,
                      ROUND(AVG(CASE WHEN n.semestre::text = '2' THEN n.valor END)::numeric, 1) AS media_2,
                      ROUND(AVG(n.valor)::numeric, 1) AS media_geral
                    FROM nota n
                    JOIN disciplina d ON d.id_disciplina = n.id_disciplina
                    WHERE n.id_aluno = ?
                    GROUP BY d.id_disciplina, d.nome
                    ORDER BY d.id_disciplina
                """;

        try (Connection conn = Conexao.conectar();
                PreparedStatement st = conn.prepareStatement(sqlBoletim)) {

            st.setInt(1, idAluno);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Linha l = new Linha();
                    l.disciplina = rs.getString("disciplina");

                    java.math.BigDecimal b1 = (java.math.BigDecimal) rs.getObject("media_1");
                    java.math.BigDecimal b2 = (java.math.BigDecimal) rs.getObject("media_2");
                    java.math.BigDecimal bg = (java.math.BigDecimal) rs.getObject("media_geral");

                    l.sem1 = (b1 == null) ? null : b1.doubleValue();
                    l.sem2 = (b2 == null) ? null : b2.doubleValue();
                    l.geral = (bg == null) ? null : bg.doubleValue();

                    linhas.add(l);
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Erro ao buscar boletim: " + e.getMessage(), e);
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "inline; filename=\"boletim_" + usuario.getLogin() + ".pdf\"");

        try {
            Document doc = new Document(PageSize.A4, 56, 56, 95, 56);
            PdfWriter writer = PdfWriter.getInstance(doc, response.getOutputStream());

            writer.setPageEvent(new PdfPageEventHelper() {
                @Override
                public void onEndPage(PdfWriter w, Document d) {
                    Rectangle page = d.getPageSize();

                    PdfContentByte under = w.getDirectContentUnder();
                    PdfContentByte over = w.getDirectContent();

                    under.saveState();
                    under.setColorFill(BG);
                    under.rectangle(page.getLeft(), page.getBottom(), page.getWidth(), page.getHeight());
                    under.fill();
                    under.restoreState();

                    under.saveState();
                    under.setColorFill(BAR);
                    under.rectangle(page.getLeft(), page.getTop() - 56, page.getWidth(), 56);
                    under.fill();
                    under.restoreState();

                    try {
                        String real = getServletContext().getRealPath(LOGO_WEB_PATH);
                        if (real != null && new java.io.File(real).exists()) {
                            Image logo = Image.getInstance(real);
                            logo.scaleToFit(90, 26);
                            logo.setAbsolutePosition(page.getLeft() + 56, page.getTop() - 46);
                            over.addImage(logo);
                        }
                    } catch (Exception ignored) {
                    }

                    ColumnText.showTextAligned(over, Element.ALIGN_CENTER,
                            new Phrase("Boletim", new Font(Font.HELVETICA, 14, Font.NORMAL, Color.WHITE)),
                            page.getWidth() / 2, page.getTop() - 33, 0);

                    String dt = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                    ColumnText.showTextAligned(over, Element.ALIGN_LEFT,
                            new Phrase("Gerado em " + dt, new Font(Font.HELVETICA, 8, Font.NORMAL, TEXT)),
                            page.getLeft() + 56, page.getBottom() + 30, 0);

                    ColumnText.showTextAligned(over, Element.ALIGN_RIGHT,
                            new Phrase("Página " + w.getPageNumber(), new Font(Font.HELVETICA, 8, Font.NORMAL, TEXT)),
                            page.getRight() - 56, page.getBottom() + 30, 0);
                }
            });

            doc.open();

            Font fTitle = new Font(Font.HELVETICA, 18, Font.BOLD, TEXT);
            Font fInfo = new Font(Font.HELVETICA, 10, Font.NORMAL, TEXT);

            doc.add(new Paragraph(usuario.getNome(), fTitle));
            doc.add(new Paragraph("Turma: " + turma + " | Login: " + usuario.getLogin(), fInfo));
            doc.add(Chunk.NEWLINE);

            PdfPTable table = new PdfPTable(new float[] { 4.6f, 1.2f, 1.2f, 1.4f });
            table.setWidthPercentage(100);

            addHeaderCell(table, "Disciplina");
            addHeaderCell(table, "1º Sem");
            addHeaderCell(table, "2º Sem");
            addHeaderCell(table, "Média");

            boolean zebra = false;
            for (Linha l : linhas) {
                Color rowBg = zebra ? Color.decode("#F6F7FB") : Color.WHITE;
                zebra = !zebra;

                addRowCell(table, l.disciplina, rowBg, Element.ALIGN_LEFT);
                addRowCell(table, fmt(l.sem1), rowBg, Element.ALIGN_CENTER);
                addRowCell(table, fmt(l.sem2), rowBg, Element.ALIGN_CENTER);
                addRowCell(table, fmt(l.geral), rowBg, Element.ALIGN_CENTER);
            }

            doc.add(table);
            doc.close();

        } catch (Exception e) {
            throw new ServletException("Erro ao gerar PDF: " + e.getMessage(), e);
        }
    }

    private static void addHeaderCell(PdfPTable table, String text) {
        Font f = new Font(Font.HELVETICA, 10, Font.BOLD, TEXT);
        PdfPCell cell = new PdfPCell(new Phrase(text, f));
        cell.setBackgroundColor(Color.decode("#EEF1F8"));
        cell.setBorderColor(Color.decode("#C9D0E5"));
        cell.setPadding(8);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);
    }

    private static void addRowCell(PdfPTable table, String text, Color bg, int align) {
        Font f = new Font(Font.HELVETICA, 9, Font.NORMAL, TEXT);
        PdfPCell cell = new PdfPCell(new Phrase(text, f));
        cell.setBackgroundColor(bg);
        cell.setBorderColor(Color.decode("#C9D0E5"));
        cell.setPadding(8);
        cell.setHorizontalAlignment(align);
        table.addCell(cell);
    }

    private static String fmt(Double v) {
        if (v == null)
            return "";
        return String.format("%.1f", v);
    }
}