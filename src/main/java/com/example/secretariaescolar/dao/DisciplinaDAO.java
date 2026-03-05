package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DisciplinaDAO {

    // Buscar disciplina por ID
    public Disciplina buscarPorId(int id) {
        String sql = "SELECT id_disciplina, nome FROM disciplina WHERE id_disciplina = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar a disciplina pelo ID: " + e.getMessage());
        }

        return null;
    }

    // Buscar disciplina pelo nome
    public Disciplina buscarPorNome(String nome) {
        String sql = "SELECT id_disciplina, nome FROM disciplina WHERE LOWER(nome) = LOWER(?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao buscar a disciplina pelo nome: " + e.getMessage());
        }

        return null;
    }

    // Listar todas as disciplinas
    public List<Disciplina> listarTodas() {
        List<Disciplina> disciplinas = new ArrayList<>();
        String sql = "SELECT id_disciplina, nome FROM disciplina ORDER BY nome";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Disciplina d = new Disciplina();
                d.setId_disciplina(rs.getInt("id_disciplina"));
                d.setNome(rs.getString("nome"));
                disciplinas.add(d);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar as disciplinas: " + e.getMessage());
        }

        return disciplinas;
    }

    // ===== PROFESSOR: disciplina do professor (por id_user do usuario logado) =====
    public Disciplina buscarDisciplinaDoProfessorPorIdUser(int idUserProfessor) {
        String sql = """
            SELECT d.id_disciplina, d.nome
            FROM professor p
            JOIN disciplina d ON d.id_disciplina = p.id_disciplina
            WHERE p.id_user = ?
            LIMIT 1
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUserProfessor);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // ===== PROFESSOR: todas as outras disciplinas (exceto a do professor) =====
    public List<Disciplina> listarOutrasDisciplinasDoProfessorPorIdUser(int idUserProfessor) {
        List<Disciplina> lista = new ArrayList<>();

        String sql = """
            SELECT d.id_disciplina, d.nome
            FROM disciplina d
            WHERE d.id_disciplina <>
                (SELECT p.id_disciplina
                 FROM professor p
                 WHERE p.id_user = ?
                 LIMIT 1)
            ORDER BY d.nome ASC
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUserProfessor);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    lista.add(d);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}