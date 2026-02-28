package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.util.Conexao;

import java.sql.*;

public class UsuarioDAO {

    public int inserir(Usuario user) {

        String sql = "INSERT INTO usuario (nome, login, senha, id_tipo_user) VALUES (?, ?, ?, ?)";
        int idGerado = -1;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getNome());
            stmt.setString(2, user.getLogin());
            stmt.setString(3, user.getSenha());
            stmt.setInt(4, user.getId_tipo_user());

            int linhas = stmt.executeUpdate();

            if (linhas > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    idGerado = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.err.println("Erro ao inserir usuário: " + e.getMessage());
        }

        return idGerado;
    }

    public Usuario autenticar(String login, String senha) {

        String sql = """
    SELECT id_user, nome, login, id_tipo_user, foto
    FROM usuario
    WHERE login = ? AND senha = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, login);
            stmt.setString(2, senha);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario user = new Usuario();
                user.setId_user(rs.getInt("id_user"));
                user.setNome(rs.getString("nome"));
                user.setLogin(rs.getString("login"));
                user.setId_tipo_user(rs.getInt("id_tipo_user"));
                user.setFoto(rs.getString("foto"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean cadastrarInfos(String matricula, String login, String senha) {

        String sql = """
            UPDATE usuario u
            SET login = ?, senha = ?
            FROM aluno a
            WHERE a.id_user = u.id_user
              AND a.matricula = ?
              AND u.login IS NULL
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, login);
            stmt.setString(2, senha);
            stmt.setString(3, matricula);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}