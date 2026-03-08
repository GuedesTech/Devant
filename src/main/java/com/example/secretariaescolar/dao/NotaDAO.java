package com.example.secretariaescolar.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Nota;
import com.example.secretariaescolar.util.Conexao;

public class NotaDAO {
    public MediaDisciplina buscarMediaDaDisciplinaPorAluno(int idAluno, int idDisciplina) {
        String sql = """
                    SELECT d.nome AS disciplina,
                           ROUND(AVG(n.valor), 2) AS media
                    FROM nota n
                    JOIN disciplina d ON d.id_disciplina = n.id_disciplina
                    WHERE n.id_aluno = ?
                      AND n.id_disciplina = ?
                    GROUP BY d.nome
                """;

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new MediaDisciplina(
                            rs.getString("disciplina"),
                            rs.getDouble("media"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public MediaDisciplina buscarMediaDaDisciplinaPorAlunoESemestre(int idAluno, int idDisciplina, String semestre) {
        String sql = """
                    SELECT d.nome AS disciplina,
                           ROUND(AVG(n.valor), 2) AS media
                    FROM nota n
                    JOIN disciplina d ON d.id_disciplina = n.id_disciplina
                    WHERE n.id_aluno = ?
                      AND n.id_disciplina = ?
                      AND n.semestre = ?
                    GROUP BY d.nome
                """;

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);
            stmt.setString(3, semestre);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new MediaDisciplina(
                            rs.getString("disciplina"),
                            rs.getDouble("media"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public int inserir(Nota nota) {
        String sql = "INSERT INTO Nota (titulo, valor, semestre, id_aluno, id_professor-disciplina) VALUES (?,?,?,?,?)";
        int idGerado = -1;

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, nota.getTitulo());
            stmt.setDouble(2, nota.getValor());
            stmt.setString(3, nota.getSemestre());
            stmt.setInt(4, nota.getId_aluno());
            stmt.setInt(5, nota.getId_professorDisciplina());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGerado = rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao inserir nota: " + e.getMessage());
        }

        return idGerado;
    }

    public List<Nota> listarPorAluno(int idAluno) {
        List<Nota> notas = new ArrayList<>();

        String sql = "SELECT * FROM Nota WHERE id_aluno = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Nota nota = new Nota();

                    nota.setId_nota(rs.getInt("id_nota"));
                    nota.setTitulo(rs.getString("titulo"));
                    nota.setSemestre(rs.getString("semestre"));
                    nota.setValor(rs.getDouble("valor"));
                    nota.setId_aluno(rs.getInt("id_aluno"));
                    nota.setId_professorDisciplina(rs.getInt("id_professor_disciplina"));

                    notas.add(nota);

                }

            }

        } catch (SQLException e) {
            System.err.println("Erro ao listar notas dos alunos: " + e.getMessage());
        }

        return notas;
    }

    public boolean atualizar(Nota nota) {
        String sql = "UPDATE Nota SET titulo = ?, valor = ?, semestre = ? WHERE id_nota = ?";

        try (Connection conn = Conexao.conectar();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nota.getTitulo());
            stmt.setDouble(2, nota.getValor());
            stmt.setString(3, nota.getSemestre());
            stmt.setInt(4, nota.getId_nota());

            int linhasAfetadas = stmt.executeUpdate();

            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("Erro ao atualizar as notas: " + e.getMessage());
            return false;
        }
    }

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
                            rs.getDouble("media")));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Quantas disciplinas com média >= 7
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
                if (rs.next())
                    return rs.getInt("qtd");
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
                if (rs.next())
                    return rs.getInt("qtd");
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
                if (rs.next())
                    return rs.getDouble("media");
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
                            rs.getDouble("media")));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}
