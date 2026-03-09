package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TurmaAdmDAO {

    public List<Turma> listar(String q) {
        List<Turma> lista = new ArrayList<>();

        String sql = """
            SELECT id_turma, nome
            FROM turma
            WHERE (? IS NULL OR LOWER(nome) LIKE ?)
            ORDER BY nome ASC
        """;

        String like = (q == null || q.isBlank()) ? null : "%" + q.toLowerCase() + "%";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, like);
            stmt.setString(2, like);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Turma t = new Turma();
                    t.setId_turma(rs.getInt("id_turma"));
                    t.setNome(rs.getString("nome"));
                    lista.add(t);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Turma buscarPorId(int idTurma) {
        String sql = "SELECT id_turma, nome FROM turma WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Turma t = new Turma();
                    t.setId_turma(rs.getInt("id_turma"));
                    t.setNome(rs.getString("nome"));
                    return t;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean inserir(String nome) {
        String sql = "INSERT INTO turma (nome) VALUES (?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idTurma, String nome) {
        String sql = "UPDATE turma SET nome = ? WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            stmt.setInt(2, idTurma);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idTurma) {
        String sql = "DELETE FROM turma WHERE id_turma = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idTurma);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}