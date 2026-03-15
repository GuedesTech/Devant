package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.util.Conexao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ObservacaoDAO {

    public boolean salvar(Observacao o) {
        String sql = """
            INSERT INTO observacao (mensagem, data, id_aluno, id_professor, id_disciplina, tipo)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, o.getMensagem());
            stmt.setDate(2, Date.valueOf(o.getData()));
            stmt.setInt(3, o.getId_aluno());
            stmt.setInt(4, o.getId_professor());
            stmt.setInt(5, o.getId_disciplina());
            stmt.setInt(6, o.getTipo());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Erro ao enviar a observação: " + e.getMessage());
            return false;
        }
    }

    public List<Observacao> listarPorAluno(int idAluno) {
        List<Observacao> lista = new ArrayList<>();

        String sql = """
            SELECT 
                o.id_observacao,
                o.mensagem,
                o.data,
                o.id_aluno,
                o.id_professor,
                o.id_disciplina,
                o.tipo,
                COALESCE(u.nome, 'Secretaria') AS nome_professor
            FROM observacao o
            LEFT JOIN professor p ON p.id_professor = o.id_professor
            LEFT JOIN usuario u ON u.id_user = p.id_user
            WHERE o.id_aluno = ?
            ORDER BY o.data DESC, o.id_observacao DESC
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Observacao o = new Observacao();
                    o.setId_observacao(rs.getInt("id_observacao"));
                    o.setMensagem(rs.getString("mensagem"));
                    o.setData(rs.getDate("data").toLocalDate());
                    o.setId_aluno(rs.getInt("id_aluno"));

                    int idProfessor = rs.getInt("id_professor");
                    o.setId_professor(rs.wasNull() ? 0 : idProfessor);

                    o.setId_disciplina(rs.getInt("id_disciplina"));
                    o.setTipo(rs.getInt("tipo"));
                    o.setNomeProfessor(rs.getString("nome_professor"));

                    lista.add(o);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }


    public List<Observacao> listarPorAlunoEDisciplina(int idAluno, int idDisciplina) {
        List<Observacao> lista = new ArrayList<>();

        String sql = """
            SELECT 
                o.id_observacao,
                o.mensagem,
                o.data,
                o.id_aluno,
                o.id_professor,
                o.id_disciplina,
                o.tipo,
                COALESCE(u.nome, 'Secretaria') AS nome_professor
            FROM observacao o
            LEFT JOIN professor p ON p.id_professor = o.id_professor
            LEFT JOIN usuario u ON u.id_user = p.id_user
            WHERE o.id_aluno = ?
              AND o.id_disciplina = ?
            ORDER BY o.data DESC, o.id_observacao DESC
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Observacao o = new Observacao();
                    o.setId_observacao(rs.getInt("id_observacao"));
                    o.setMensagem(rs.getString("mensagem"));
                    o.setData(rs.getDate("data").toLocalDate());
                    o.setId_aluno(rs.getInt("id_aluno"));

                    int idProfessor = rs.getInt("id_professor");
                    o.setId_professor(rs.wasNull() ? 0 : idProfessor);

                    o.setId_disciplina(rs.getInt("id_disciplina"));
                    o.setTipo(rs.getInt("tipo"));
                    o.setNomeProfessor(rs.getString("nome_professor"));

                    lista.add(o);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int contarPorAlunoETipo(int idAluno, int tipo) {
        String sql = "SELECT COUNT(*) FROM observacao WHERE id_aluno = ? AND tipo = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, tipo);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarTotalPorAluno(int idAluno) {
        String sql = "SELECT COUNT(*) FROM observacao WHERE id_aluno = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarTotalPorAlunoEDisciplina(int idAluno, int idDisciplina) {
        String sql = """
            SELECT COUNT(*) AS total
            FROM observacao
            WHERE id_aluno = ? AND id_disciplina = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int contarPorAlunoETipoEDisciplina(int idAluno, int tipo, int idDisciplina) {
        String sql = """
            SELECT COUNT(*) AS total
            FROM observacao
            WHERE id_aluno = ? AND tipo = ? AND id_disciplina = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idAluno);
            stmt.setInt(2, tipo);
            stmt.setInt(3, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public Observacao buscarPorId(int idObservacao) {
        String sql = """
            SELECT 
                o.id_observacao,
                o.mensagem,
                o.data,
                o.id_aluno,
                o.id_professor,
                o.id_disciplina,
                o.tipo,
                u.nome AS nome_professor
            FROM observacao o
            INNER JOIN professor p ON p.id_professor = o.id_professor
            INNER JOIN usuario u ON u.id_user = p.id_user
            WHERE o.id_observacao = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idObservacao);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Observacao o = new Observacao();
                    o.setId_observacao(rs.getInt("id_observacao"));
                    o.setMensagem(rs.getString("mensagem"));
                    o.setData(rs.getDate("data").toLocalDate());
                    o.setId_aluno(rs.getInt("id_aluno"));
                    o.setId_professor(rs.getInt("id_professor"));
                    o.setId_disciplina(rs.getInt("id_disciplina"));
                    o.setTipo(rs.getInt("tipo"));
                    o.setNomeProfessor(rs.getString("nome_professor"));
                    return o;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean inserirProfessor(int idAluno, int idProfessor, int idDisciplina, String mensagem, int tipo) {
        String sql = """
            INSERT INTO observacao (mensagem, data, id_aluno, id_professor, id_disciplina, tipo)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mensagem);
            stmt.setDate(2, Date.valueOf(LocalDate.now()));
            stmt.setInt(3, idAluno);
            stmt.setInt(4, idProfessor);
            stmt.setInt(5, idDisciplina);
            stmt.setInt(6, tipo);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarDoProfessor(int idObservacao, String mensagem, int tipo) {
        String sql = """
            UPDATE observacao
            SET mensagem = ?, tipo = ?
            WHERE id_observacao = ?
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, mensagem);
            stmt.setInt(2, tipo);
            stmt.setInt(3, idObservacao);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluirDoProfessor(int idObservacao) {
        String sql = "DELETE FROM observacao WHERE id_observacao = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idObservacao);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}