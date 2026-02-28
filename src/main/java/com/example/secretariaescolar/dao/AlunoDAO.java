package com.example.secretariaescolar.dao;

import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlunoDAO {

    public boolean cadastrar(Aluno aluno) {

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        int idGerado = usuarioDAO.inserir(aluno);

        if (idGerado > 0) {

            aluno.setId_user(idGerado);

            String sql = "INSERT INTO aluno (id_user, matricula, id_turma) VALUES (?, ?, ?)";

            try (Connection conn = Conexao.conectar();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, aluno.getId_user());
                stmt.setString(2, aluno.getMatricula());
                stmt.setInt(3, aluno.getId_turma());

                stmt.executeUpdate();
                return true;

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    public Integer buscarIdPorMatricula(String matricula) {

        String sql = "SELECT id_aluno FROM aluno WHERE matricula = ?";

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, matricula);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("id_aluno");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Aluno> listarTodos() {

        List<Aluno> lista = new ArrayList<>();

        String sql = """
            SELECT u.id_user, u.nome, u.login,
                   a.id_aluno, a.matricula, a.id_turma
            FROM usuario u
            INNER JOIN aluno a ON u.id_user = a.id_user
            """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Aluno aluno = new Aluno();

                aluno.setId_user(rs.getInt("id_user"));
                aluno.setNome(rs.getString("nome"));
                aluno.setLogin(rs.getString("login"));
                aluno.setId_aluno(rs.getInt("id_aluno"));
                aluno.setMatricula(rs.getString("matricula"));
                aluno.setId_turma(rs.getInt("id_turma"));

                lista.add(aluno);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public boolean podeCadastrarLogin(String matricula) {

        String sql = """
        SELECT u.login, u.senha
        FROM aluno a
        INNER JOIN usuario u ON a.id_user = u.id_user
        WHERE a.matricula = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, matricula);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                String login = rs.getString("login");
                String senha = rs.getString("senha");

                // Se ambos forem NULL, pode cadastrar
                return login == null && senha == null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false; // matrícula não existe ou erro
    }

    public Aluno buscarPorIdUser(int idUser) {

        String sql = """
        SELECT u.id_user, u.nome, u.login, u.foto,
               a.id_aluno, a.matricula, a.id_turma,
               t.nome AS nome_turma
        FROM usuario u
        INNER JOIN aluno a ON u.id_user = a.id_user
        INNER JOIN turma t ON t.id_turma = a.id_turma
        WHERE u.id_user = ?
    """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUser);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    Aluno aluno = new Aluno();

                    aluno.setId_user(rs.getInt("id_user"));
                    aluno.setNome(rs.getString("nome"));
                    aluno.setLogin(rs.getString("login"));
                    aluno.setFoto(rs.getString("foto")); // pode ser null

                    aluno.setId_aluno(rs.getInt("id_aluno"));
                    aluno.setMatricula(rs.getString("matricula"));
                    aluno.setId_turma(rs.getInt("id_turma"));

                    // ✅ aqui vem o nome da turma
                    aluno.setNomeTurma(rs.getString("nome_turma"));

                    return aluno;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}