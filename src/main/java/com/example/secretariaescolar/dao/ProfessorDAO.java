package com.example.secretariaescolar.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Professor;
import com.example.secretariaescolar.util.Conexao;

public class ProfessorDAO {

    public Professor buscaPorUsuario(int id_user) {
        String sql = "SELECT u.id_user, u.nome, u.login, u.senha, u.foto, p.id_professor " +
                "FROM usuario u " +
                "INNER JOIN professor p ON u.id_user = p.id_user " +
                "WHERE u.id_user = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id_user);

            try (ResultSet rset = pstmt.executeQuery()) {
                if (rset.next()) {
                    Professor professor = new Professor();
                    professor.setId_user(rset.getInt("id_user"));
                    professor.setNome(rset.getString("nome"));
                    professor.setLogin(rset.getString("login"));
                    professor.setSenha(rset.getString("senha"));
                    professor.setFoto(rset.getString("foto"));
                    professor.setId_professor(rset.getInt("id_professor"));

                    return professor;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar professor: " + e.getMessage());
        }

        return null;
    }

    public Disciplina getDisciplina(int id_professor) {
        String sql = """
        SELECT d.id_disciplina, d.nome
        FROM professor p
        INNER JOIN disciplina d ON d.id_disciplina = p.id_disciplina
        WHERE p.id_professor = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id_professor);

            try (ResultSet rset = pstmt.executeQuery()) {
                if (rset.next()) {
                    Disciplina disciplina = new Disciplina();
                    disciplina.setId_disciplina(rset.getInt("id_disciplina"));
                    disciplina.setNome(rset.getString("nome"));
                    return disciplina;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao pegar a disciplina do professor: " + e.getMessage());
        }

        return null;
    }

    public Integer buscarPrimeiroProfessorDaDisciplina(int idDisciplina) {
        String sql = """
            SELECT id_professor
            FROM professor
            WHERE id_disciplina = ?
            ORDER BY id_professor ASC
            LIMIT 1
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt("id_professor");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer buscarIdProfessorPorIdUser(int idUser) {
        String sql = "SELECT id_professor FROM professor WHERE id_user = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUser);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_professor");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}