package com.example.secretariaescolar.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.example.secretariaescolar.dto.NotasAlunoDTO;
import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Nota;
import com.example.secretariaescolar.util.Conexao;

public class NotaDAO {
    public List<Nota> listarPorProfessorDisciplina(int idProfessorDisciplina) {
        List<Nota> notas = new ArrayList<>();

        String sql = "SELECT * FROM Nota WHERE id_professor-disciplina = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProfessorDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Nota nota = new Nota();

                    nota.setId_nota(rs.getInt("id_nota"));
                    nota.setTitulo(rs.getString("titulo"));
                    nota.setValor(rs.getDouble("valor"));
                    nota.setSemestre(rs.getString("semestre"));
                    nota.setId_aluno(rs.getInt("id_aluno"));
                    nota.setId_professorDisciplina(rs.getInt("id_professor_disciplina"));

                    notas.add(nota);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao listar por professor/disciplina: " + e.getMessage());
        }
        return notas;
    }

    public Nota buscarPorId(int idNota) {
        String sql = "SELECT * FROM Nota WHERE id_nota = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idNota);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Nota nota = new Nota();

                    nota.setId_nota(rs.getInt("id_nota"));
                    nota.setTitulo(rs.getString("titulo"));
                    nota.setValor(rs.getDouble("valor"));
                    nota.setSemestre(rs.getString("semestre"));
                    nota.setId_aluno(rs.getInt("id_aluno"));
                    nota.setId_professorDisciplina(rs.getInt("id_professor_disciplina"));

                    return nota;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar nota por ID: " + e.getMessage());
        }

        return null;
    }

    public boolean deletar(int idNota) {

        String sql = "DELETE FROM Nota WHERE id_nota = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idNota);

            int linhasAfetadas = stmt.executeUpdate();

            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao deletar nota: " + e.getMessage());
            return false;
        }
    }

    public List<MediaDisciplina> listarMediasPorDisciplina(int idAluno) {
        List<MediaDisciplina> lista = new ArrayList<>();

        String sql = """
            SELECT d.nome AS disciplina,
                   ROUND(AVG(n.valor), 2) AS media
            FROM nota n
            JOIN disciplina d ON d.id_disciplina = n.id_disciplina
            WHERE n.id_aluno = ?
            GROUP BY d.nome
            ORDER BY d.nome
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(new MediaDisciplina(
                            rs.getString("disciplina"),
                            rs.getDouble("media")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int contarDisciplinasAcimaOuIgual7(int idAluno) {
        String sql = """
            SELECT COUNT(*) AS qtd
            FROM (
                SELECT n.id_disciplina
                FROM nota n
                WHERE n.id_aluno = ?
                GROUP BY n.id_disciplina
                HAVING AVG(n.valor) >= 7
            ) x
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("qtd");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Quantas disciplinas com média < 7
    public int contarDisciplinasAbaixo7(int idAluno) {
        String sql = """
            SELECT COUNT(*) AS qtd
            FROM (
                SELECT n.id_disciplina
                FROM nota n
                WHERE n.id_aluno = ?
                GROUP BY n.id_disciplina
                HAVING AVG(n.valor) < 7
            ) x
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("qtd");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public double calcularMediaGeral(int idAluno) {
        String sql = "SELECT ROUND(AVG(valor), 2) AS media FROM nota WHERE id_aluno = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble("media");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public List<MediaDisciplina> listarMediasPorDisciplinaPorSemestre(int idAluno, String semestre) {
        List<MediaDisciplina> lista = new ArrayList<>();

        String sql = """
        SELECT d.nome AS disciplina,
               ROUND(AVG(n.valor), 2) AS media
        FROM nota n
        JOIN disciplina d ON d.id_disciplina = n.id_disciplina
        WHERE n.id_aluno = ? AND n.semestre = ?
        GROUP BY d.nome
        ORDER BY d.nome
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setString(2, semestre);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(new MediaDisciplina(
                            rs.getString("disciplina"),
                            rs.getDouble("media")
                    ));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public NotasAlunoDTO buscarN1N2(int idAluno, int idDisciplina) {
        String sql = """
            SELECT semestre, valor
            FROM nota
            WHERE id_aluno = ? AND id_disciplina = ? AND semestre IN ('1','2')
        """;

        NotasAlunoDTO dto = new NotasAlunoDTO();
        dto.setN1(0.0);
        dto.setN2(0.0);

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String s = rs.getString("semestre");
                    double v = rs.getDouble("valor");
                    if ("1".equals(s)) dto.setN1(v);
                    if ("2".equals(s)) dto.setN2(v);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }

    public boolean salvarOuAtualizarN1N2(int idAluno, int idDisciplina, int idProfessor,
                                         double n1, double n2) {

        // upsert manual: tenta UPDATE, se 0 rows, faz INSERT
        String up1 = "UPDATE nota SET valor=?, titulo='Nota', id_professor=? WHERE id_aluno=? AND id_disciplina=? AND semestre='1'";
        String in1 = "INSERT INTO nota (titulo, valor, semestre, id_aluno, id_professor, id_disciplina) VALUES ('Nota', ?, '1', ?, ?, ?)";

        String up2 = "UPDATE nota SET valor=?, titulo='Nota', id_professor=? WHERE id_aluno=? AND id_disciplina=? AND semestre='2'";
        String in2 = "INSERT INTO nota (titulo, valor, semestre, id_aluno, id_professor, id_disciplina) VALUES ('Nota', ?, '2', ?, ?, ?)";

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            // N1
            int rows1;
            try (PreparedStatement s = conn.prepareStatement(up1)) {
                s.setDouble(1, n1);
                s.setInt(2, idProfessor);
                s.setInt(3, idAluno);
                s.setInt(4, idDisciplina);
                rows1 = s.executeUpdate();
            }
            if (rows1 == 0) {
                try (PreparedStatement s = conn.prepareStatement(in1)) {
                    s.setDouble(1, n1);
                    s.setInt(2, idAluno);
                    s.setInt(3, idProfessor);
                    s.setInt(4, idDisciplina);
                    s.executeUpdate();
                }
            }

            // N2
            int rows2;
            try (PreparedStatement s = conn.prepareStatement(up2)) {
                s.setDouble(1, n2);
                s.setInt(2, idProfessor);
                s.setInt(3, idAluno);
                s.setInt(4, idDisciplina);
                rows2 = s.executeUpdate();
            }
            if (rows2 == 0) {
                try (PreparedStatement s = conn.prepareStatement(in2)) {
                    s.setDouble(1, n2);
                    s.setInt(2, idAluno);
                    s.setInt(3, idProfessor);
                    s.setInt(4, idDisciplina);
                    s.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
