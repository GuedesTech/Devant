package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Disciplina;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DisciplinaDAO {
    private Connection conn;

    public DisciplinaDAO(Connection conn) {
        this.conn = conn;
    }

    // Buscar disciplina por ID
    public Disciplina buscarPorId(int id) {
        String sql = "SELECT * FROM disciplina WHERE id_disciplina = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Disciplina(
                        rs.getInt("id_disciplina"),
                        rs.getString("nome")
                );
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar a disciplina pelo ID: " + e.getMessage());
        }

        return null;
    }

    // Buscar disciplina pelo nome
    public Disciplina buscarPorNome(String nome) {
        String sql = "SELECT * FROM disciplina WHERE LOWER(nome) = LOWER(?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, nome);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Disciplina(
                        rs.getInt("id_disciplina"),
                        rs.getString("nome")
                );
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

        try (PreparedStatement stmt = conn.prepareStatement(sql);
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
}