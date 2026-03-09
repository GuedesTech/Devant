package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.util.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DisciplinaAdmDAO {

    public List<Disciplina> listar(String q) {
        List<Disciplina> lista = new ArrayList<>();

        String sql = """
            SELECT id_disciplina, nome
            FROM disciplina
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
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    lista.add(d);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Disciplina buscarPorId(int idDisciplina) {
        String sql = "SELECT id_disciplina, nome FROM disciplina WHERE id_disciplina = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Disciplina d = new Disciplina();
                    d.setId_disciplina(rs.getInt("id_disciplina"));
                    d.setNome(rs.getString("nome"));
                    return d;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean inserir(String nome) {
        String sql = "INSERT INTO disciplina (nome) VALUES (?)";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int idDisciplina, String nome) {
        String sql = "UPDATE disciplina SET nome = ? WHERE id_disciplina = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nome);
            stmt.setInt(2, idDisciplina);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean excluir(int idDisciplina) {
        String sql = "DELETE FROM disciplina WHERE id_disciplina = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idDisciplina);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}